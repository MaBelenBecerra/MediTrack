import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditrack_design_system/design_system.dart';
import 'package:provider/provider.dart';

import '../../core/utils/permission_manager.dart';
import '../../data/models/medication_model.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../adherence/adherence_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'MediTrack',
          style: AppTypography.titleLarge.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdherenceScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isOffline) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modo sin conexión. Mostrando datos locales.'),
                  backgroundColor: AppColors.alert,
                  duration: Duration(seconds: 3),
                ),
              );
            });
          }

          if (viewModel.medications.isEmpty) {
            return const Center(
              child: Text(
                'No tienes medicamentos programados hoy.',
                style: AppTypography.body,
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: viewModel.medications.length,
            itemBuilder: (context, index) {
              final med = viewModel.medications[index];

              return Card(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 12.h),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: med.imagePath != null && med.imagePath!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              File(med.imagePath!),
                              width: 55.w,
                              height: 55.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            radius: 25.r,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Icons.medication, color: AppColors.primary, size: 28.sp),
                          ),
                    title: Text(
                      med.nombre,
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.vaccines, size: 16.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(med.dosis, style: AppTypography.body),
                          SizedBox(width: 12.w),
                          Icon(Icons.access_time, size: 16.sp, color: AppColors.primary),
                          SizedBox(width: 4.w),
                          Text(
                            med.hora,
                            style: AppTypography.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 32),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Pastilla marcada como tomada!')),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await PermissionManager.requestAppPermissions();
          if (context.mounted) {
            _mostrarDialogoAgregar(context);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _mostrarDialogoAgregar(BuildContext context) {
    final nombreController = TextEditingController();
    final dosisController = TextEditingController();
    
    TimeOfDay? horaSeleccionada;
    String? rutaImagen;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              title: const Text('Nuevo Medicamento', style: AppTypography.titleMedium),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la pastilla',
                        prefixIcon: const Icon(Icons.medication),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: dosisController,
                      decoration: InputDecoration(
                        labelText: 'Dosis (ej. 1 pastilla)',
                        prefixIcon: const Icon(Icons.format_list_numbered),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      leading: const Icon(Icons.access_time, color: AppColors.primary),
                      title: Text(
                        horaSeleccionada == null 
                            ? 'Seleccionar Hora' 
                            : horaSeleccionada!.format(context),
                        style: TextStyle(
                          color: horaSeleccionada == null ? Colors.grey : Colors.black,
                          fontWeight: horaSeleccionada == null ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setStateDialog(() => horaSeleccionada = picked);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),

                    if (rutaImagen != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(File(rutaImagen!), height: 100.h, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),
                      
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(double.infinity, 45.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: Text(rutaImagen == null ? 'Tomar Foto' : 'Cambiar Foto', style: const TextStyle(color: Colors.white)),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? foto = await picker.pickImage(source: ImageSource.camera);
                        
                        if (foto != null) {
                          setStateDialog(() => rutaImagen = foto.path);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    if (nombreController.text.isEmpty || dosisController.text.isEmpty || horaSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor llena todos los datos y la hora')),
                      );
                      return;
                    }

                    final nuevoMedicamento = MedicationModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nombre: nombreController.text,
                      dosis: dosisController.text,
                      hora: horaSeleccionada!.format(context),
                      imagePath: rutaImagen,
                    );

                    context.read<DashboardViewModel>().addMedication(nuevoMedicamento);
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
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
                margin: EdgeInsets.only(bottom: 16.h),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      // Previsualización de foto en miniatura redondeada
                      med.imagePath != null && med.imagePath!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(
                                File(med.imagePath!),
                                width: 65.w,
                                height: 65.w,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 65.w,
                              height: 65.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Icon(
                                Icons.medication,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.nombre,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Dosis: ${med.dosis}',
                              style: AppTypography.body.copyWith(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppColors.primary),
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
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 36,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Pastilla marcada como tomada!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
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
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo Medicamento',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre de la pastilla',
                          prefixIcon: const Icon(Icons.medication),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: dosisController,
                        decoration: InputDecoration(
                          labelText: 'Dosis (ej. 1 pastilla)',
                          prefixIcon: const Icon(Icons.format_list_numbered),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      // Selector de hora tipo botón moderno
                      InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setStateDialog(() => horaSeleccionada = picked);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: AppColors.primary),
                              SizedBox(width: 12.w),
                              Text(
                                horaSeleccionada == null 
                                    ? 'Seleccionar Hora de Toma' 
                                    : 'Hora: ${horaSeleccionada!.format(context)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: horaSeleccionada == null ? Colors.grey.shade600 : Colors.black,
                                  fontWeight: horaSeleccionada == null ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Previsualización de la foto dentro del modal
                      if (rutaImagen != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(rutaImagen!), 
                            height: 120.h, 
                            width: double.infinity, 
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                        
                      // Botón para tomar fotografía
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(
                          rutaImagen == null ? 'Tomar Foto de la Pastilla' : 'Cambiar Fotografía', 
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final XFile? foto = await picker.pickImage(source: ImageSource.camera);
                          if (foto != null) {
                            setStateDialog(() => rutaImagen = foto.path);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      
                      // Acciones inferiores (Guardar / Cancelar)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ),
                          SizedBox(width: 8.w),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () {
                              if (nombreController.text.isEmpty || dosisController.text.isEmpty || horaSeleccionada == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor completa todos los campos y define la hora.'),
                                    backgroundColor: Colors.red,
                                  ),
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
                            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
}
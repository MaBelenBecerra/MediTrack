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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'MediTrack',
          style: AppTypography.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF005088),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005088), Color(0xFF007BBF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF005088)..withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Progreso de Hoy!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Tienes notificaciones pendientes para tus tomas de la tarde.',
                            style: TextStyle(
                              color: Colors.white..withValues(alpha: 0.85),
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.notifications_active, color: const Color(0xFF11CAA0), size: 40.sp),
                  ],
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  'Tus Medicamentos',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF005088),
                  ),
                ),
              ),

              Expanded(
                child: viewModel.medications.isEmpty
                    ? const Center(child: Text('No hay medicamentos programados.'))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: viewModel.medications.length,
                        itemBuilder: (context, index) {
                          final med = viewModel.medications[index];
                          
                          final List<Color> indicatorColors = [const Color(0xFF005088), const Color(0xFF11CAA0), const Color(0xFF9333EA)];
                          final Color sideColor = indicatorColors[index % indicatorColors.length];

                          return Container(
                            margin: EdgeInsets.only(bottom: 14.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black..withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  // Línea decorativa izquierda de Figma
                                  Container(
                                    width: 6.w,
                                    decoration: BoxDecoration(
                                      color: sideColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        bottomLeft: Radius.circular(16.r),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  
                                  // Imagen o Icono Circular
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    key: ValueKey(med.id),
                                    child: med.imagePath != null && med.imagePath!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(12.r),
                                            child: Image.file(
                                              File(med.imagePath!),
                                              width: 55.w,
                                              height: 55.w,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            width: 55.w,
                                            height: 55.w,
                                            decoration: BoxDecoration(
                                              color: sideColor..withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            child: Icon(Icons.medication, color: sideColor, size: 28),
                                          ),
                                  ),
                                  SizedBox(width: 14.w),
                                  
                                  // Textos descriptivos
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          med.nombre,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1E293B),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Dosis: ${med.dosis}',
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
                                        ),
                                        SizedBox(height: 4.h),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time_filled, size: 14.sp, color: sideColor),
                                            SizedBox(width: 4.w),
                                            Text(
                                              med.hora,
                                              style: TextStyle(
                                                color: sideColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Botón de confirmación Check
                                  IconButton(
                                    icon: const Icon(Icons.check_circle, color: Color(0xFF11CAA0), size: 34),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF11CAA0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        onPressed: () async {
          await PermissionManager.requestAppPermissions();
          if (context.mounted) {
            _mostrarDialogoAgregar(context);
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _mostrarDialogoAgregar(BuildContext context) {
    final nombreController = TextEditingController();
    final dosisController = TextEditingController();
    TimeOfDay? horaSeleccionada;
    String? rutaImagen;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24.w, left: 24.w, right: 24.w,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.w,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agregar Medicamento',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF005088)),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la pastilla',
                        prefixIcon: const Icon(Icons.medication, color: Color(0xFF005088)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    TextField(
                      controller: dosisController,
                      decoration: InputDecoration(
                        labelText: 'Dosis (ej. 1 tableta)',
                        prefixIcon: const Icon(Icons.numbers, color: Color(0xFF005088)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      leading: const Icon(Icons.alarm, color: Color(0xFF11CAA0)),
                      title: Text(
                        horaSeleccionada == null ? 'Establecer Horario' : 'Hora: ${horaSeleccionada!.format(context)}',
                        style: TextStyle(fontWeight: horaSeleccionada == null ? FontWeight.normal : FontWeight.bold),
                      ),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (picked != null) setStateDialog(() => horaSeleccionada = picked);
                      },
                    ),
                    SizedBox(height: 16.h),

                    if (rutaImagen != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: Image.file(File(rutaImagen!), height: 120.h, width: double.infinity, fit: BoxFit.cover),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005088),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: Text(rutaImagen == null ? 'Tomar Foto' : 'Cambiar Foto', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? foto = await picker.pickImage(source: ImageSource.camera);
                        if (foto != null) setStateDialog(() => rutaImagen = foto.path);
                      },
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF11CAA0),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                            ),
                            onPressed: () {
                              if (nombreController.text.isEmpty || dosisController.text.isEmpty || horaSeleccionada == null) return;
                              final nuevo = MedicationModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                nombre: nombreController.text,
                                dosis: dosisController.text,
                                hora: horaSeleccionada!.format(context),
                                imagePath: rutaImagen,
                              );
                              context.read<DashboardViewModel>().addMedication(nuevo);
                              Navigator.pop(context);
                            },
                            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
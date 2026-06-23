import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/utils/permission_manager.dart';
import '../../data/models/medication_model.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Consumer<DashboardViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola,',
                            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
                          ),
                          Text(
                            'Paciente',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 26.r,
                        backgroundColor: const Color(0xFF0066FF).withValues(alpha: 0.1),
                        child: const Icon(Icons.person, color: Color(0xFF0066FF)),
                      ),
                    ],
                  ),
                ),

                //BANNER DE RECORDATORIO
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066FF),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0066FF).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
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
                              '¡Recordatorio!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Tienes tomas pendientes\npara el día de hoy.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14.sp,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                //TÍTULO DE LA LISTA
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tus Medicamentos',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                      ),
                      Text(
                        '${viewModel.medications.length} programados',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                //LISTA DE PASTILLAS CON SWITCH
                Expanded(
                  child: viewModel.medications.isEmpty
                      ? const Center(child: Text('No hay pastillas programadas.'))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          itemCount: viewModel.medications.length,
                          itemBuilder: (context, index) {
                            final med = viewModel.medications[index];
                            final List<Color> colors = [const Color(0xFF0066FF), const Color(0xFF11CAA0), const Color(0xFF9333EA)];
                            final Color cardColor = colors[index % colors.length];

                            return MedicationCard(med: med, cardColor: cardColor);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      // BOTÓN FLOTANTE
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF11CAA0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        onPressed: () async {
          await PermissionManager.requestAppPermissions();
          if (context.mounted) _mostrarDialogoAgregar(context);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24.w, 
                left: 24.w, 
                right: 24.w,
                bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24.w,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Agregar Medicamento', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                    SizedBox(height: 24.h),
                    
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la pastilla',
                        prefixIcon: const Icon(Icons.medical_services_outlined, color: Color(0xFF0066FF)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    TextField(
                      controller: dosisController,
                      decoration: InputDecoration(
                        labelText: 'Dosis (ej. 1 tableta)',
                        prefixIcon: const Icon(Icons.view_list_outlined, color: Color(0xFF0066FF)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (picked != null) setStateDialog(() => horaSeleccionada = picked);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFF11CAA0)),
                            SizedBox(width: 12.w),
                            Text(
                              horaSeleccionada == null ? 'Establecer Horario' : horaSeleccionada!.format(context),
                              style: TextStyle(fontSize: 16.sp, color: horaSeleccionada == null ? Colors.grey.shade600 : const Color(0xFF1E293B)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    if (rutaImagen != null) ...[
                      ClipRRect(borderRadius: BorderRadius.circular(12.r), child: Image.file(File(rutaImagen!), height: 100.h, width: double.infinity, fit: BoxFit.cover)),
                      SizedBox(height: 12.h),
                    ],

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        minimumSize: Size(double.infinity, 54.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                      label: Text(rutaImagen == null ? 'Tomar Foto' : 'Cambiar Foto', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        final foto = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (foto != null) setStateDialog(() => rutaImagen = foto.path);
                      },
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF11CAA0),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            ),
                            onPressed: () {
                              if (nombreController.text.isEmpty || horaSeleccionada == null) return;
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
                            child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

class MedicationCard extends StatefulWidget {
  final MedicationModel med;
  final Color cardColor;

  const MedicationCard({super.key, required this.med, required this.cardColor});

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  bool isTaken = false; // Estado local para el Switch

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: widget.cardColor, width: 4.w)),
          ),
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Foto o Ícono
              widget.med.imagePath != null && widget.med.imagePath!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(File(widget.med.imagePath!), width: 50.w, height: 50.w, fit: BoxFit.cover),
                    )
                  : Container(
                      width: 50.w, height: 50.w,
                      decoration: BoxDecoration(color: widget.cardColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
                      child: Icon(Icons.medication, color: widget.cardColor),
                    ),
              SizedBox(width: 16.w),
              
              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.med.nombre, 
                      style: TextStyle(
                        fontSize: 16.sp, 
                        fontWeight: FontWeight.bold, 
                        color: const Color(0xFF1E293B),
                        decoration: isTaken ? TextDecoration.lineThrough : null, // Tacha el texto si ya se tomó
                      )
                    ),
                    SizedBox(height: 4.h),
                    Text(widget.med.dosis, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500)),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14.sp, color: widget.cardColor),
                        SizedBox(width: 4.w),
                        Text(widget.med.hora, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: widget.cardColor)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Switch
              Switch(
                value: isTaken,
                activeColor: widget.cardColor,
                onChanged: (value) {
                  setState(() {
                    isTaken = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value ? 'Medicamento marcado como tomado' : 'Medicamento desmarcado'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
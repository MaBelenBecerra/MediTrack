import 'dart:io';
import 'package:flutter/material.dart';
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
        child: SingleChildScrollView(
          child: Consumer<DashboardViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola,',
                              style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600),
                            ),
                            const Text(
                              'María Belén',
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 26.0,
                          backgroundColor: const Color(0xFF0066FF).withValues(alpha: 0.1),
                          child: const Icon(Icons.person, color: Color(0xFF0066FF)),
                        ),
                      ],
                    ),
                  ),

                  // BANNER DE RECORDATORIO
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0066FF).withValues(alpha: 0.3),
                          blurRadius: 15.0,
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
                              const Text(
                                '¡Recordatorio!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Tienes tomas pendientes\npara el día de hoy.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14.0,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_active, color: Colors.white, size: 32.0),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // TÍTULO DE LA LISTA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tus Medicamentos',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        Text(
                          '${viewModel.medications.length} programados',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // LISTA DE PASTILLAS CON SWITCH
                  viewModel.medications.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('No hay pastillas programadas.'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: viewModel.medications.length,
                          itemBuilder: (context, index) {
                            final med = viewModel.medications[index];
                            final List<Color> colors = [const Color(0xFF0066FF), const Color(0xFF11CAA0), const Color(0xFF9333EA)];
                            final Color cardColor = colors[index % colors.length];

                            return MedicationCard(med: med, cardColor: cardColor);
                          },
                        ),
                  
                  const SizedBox(height: 100.0),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF11CAA0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        onPressed: () async {
          await PermissionManager.requestAppPermissions();
          if (context.mounted) _mostrarDialogoAgregar(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28.0),
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 24.0, 
                    left: 24.0, 
                    right: 24.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Agregar Medicamento', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const SizedBox(height: 24.0),
                        
                        TextField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre de la pastilla',
                            prefixIcon: const Icon(Icons.medical_services_outlined, color: Color(0xFF0066FF)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        
                        TextField(
                          controller: dosisController,
                          decoration: InputDecoration(
                            labelText: 'Dosis (ej. 1 tableta)',
                            prefixIcon: const Icon(Icons.view_list_outlined, color: Color(0xFF0066FF)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        
                        InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            if (picked != null) setStateDialog(() => horaSeleccionada = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12.0)),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, color: Color(0xFF11CAA0)),
                                const SizedBox(width: 12.0),
                                Text(
                                  horaSeleccionada == null ? 'Establecer Horario' : horaSeleccionada!.format(context),
                                  style: TextStyle(fontSize: 16.0, color: horaSeleccionada == null ? Colors.grey.shade600 : const Color(0xFF1E293B)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        if (rutaImagen != null) ...[
                          ClipRRect(borderRadius: BorderRadius.circular(12.0), child: Image.file(File(rutaImagen!), height: 100.0, width: double.infinity, fit: BoxFit.cover)),
                          const SizedBox(height: 12.0),
                        ],

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066FF),
                            minimumSize: const Size(double.infinity, 54.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                          label: Text(rutaImagen == null ? 'Tomar Foto' : 'Cambiar Foto', style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            final foto = await ImagePicker().pickImage(source: ImageSource.camera);
                            if (foto != null) setStateDialog(() => rutaImagen = foto.path);
                          },
                        ),
                        const SizedBox(height: 24.0),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF11CAA0),
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                                child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
  bool isTaken = false; 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10.0, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: widget.cardColor, width: 4.0)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              widget.med.imagePath != null && widget.med.imagePath!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(File(widget.med.imagePath!), width: 50.0, height: 50.0, fit: BoxFit.cover),
                    )
                  : Container(
                      width: 50.0, height: 50.0,
                      decoration: BoxDecoration(color: widget.cardColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.0)),
                      child: Icon(Icons.medication, color: widget.cardColor),
                    ),
              const SizedBox(width: 16.0),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.med.nombre, 
                      style: TextStyle(
                        fontSize: 16.0, 
                        fontWeight: FontWeight.bold, 
                        color: const Color(0xFF1E293B),
                        decoration: isTaken ? TextDecoration.lineThrough : null, 
                      )
                    ),
                    const SizedBox(height: 4.0),
                    Text(widget.med.dosis, style: TextStyle(fontSize: 13.0, color: Colors.grey.shade500)),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14.0, color: widget.cardColor),
                        const SizedBox(width: 4.0),
                        Text(widget.med.hora, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: widget.cardColor)),
                      ],
                    ),
                  ],
                ),
              ),
              
              Switch(
                value: isTaken,
                activeThumbColor: widget.cardColor,
                onChanged: (value) {
                  setState(() {
                    isTaken = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
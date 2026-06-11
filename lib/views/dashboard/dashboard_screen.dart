import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/design_system/design_system.dart';
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
          style: AppTypography.titleLarge.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.analytics,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdherenceScreen(),
              ),
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
                  content: Text(
                    'Modo sin conexión. Mostrando datos locales.',
                  ),
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
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      Icons.medication,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    med.nombre,
                    style: AppTypography.titleMedium,
                  ),
                  subtitle: Text(
                    '${med.dosis} • ${med.hora}',
                    style: AppTypography.body,
                  ),
                  trailing: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _mostrarDialogoAgregar(BuildContext context) {
    final nombreController = TextEditingController();
    final dosisController = TextEditingController();
    final horaController = TextEditingController();

    String? rutaImagen;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Nuevo Medicamento',
            style: AppTypography.titleMedium,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la pastilla',
                  ),
                ),
                TextField(
                  controller: dosisController,
                  decoration: const InputDecoration(
                    labelText: 'Dosis (ej. 1 pastilla)',
                  ),
                ),
                TextField(
                  controller: horaController,
                  decoration: const InputDecoration(
                    labelText: 'Hora (ej. 08:00 AM)',
                  ),
                ),

                SizedBox(height: 16.h),

                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar Foto a la Pastilla'),
                  onPressed: () async {
                    final picker = ImagePicker();

                    final XFile? foto = await picker.pickImage(
                      source: ImageSource.camera,
                    );

                    if (foto != null) {
                      rutaImagen = foto.path;

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Foto capturada correctamente'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.textGray,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                final nuevoMedicamento = MedicationModel(
                  id: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(),
                  nombre: nombreController.text,
                  dosis: dosisController.text,
                  hora: horaController.text,
                  imagePath: rutaImagen,
                );

                context
                    .read<DashboardViewModel>()
                    .addMedication(nuevoMedicamento);

                Navigator.pop(context);
              },
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
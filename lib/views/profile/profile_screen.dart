import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditrack_design_system/app_colors.dart';
import 'package:meditrack_design_system/app_typography.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final userEmail = authViewModel.currentUser?.email ?? 'Usuario Invitado';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Paciente Activo',
              style: AppTypography.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              userEmail,
              style: AppTypography.body,
            ),

            const SizedBox(height: 40),

            // Botón de cerrar sesión
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await authViewModel.logout();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // Botón de diagnóstico de hardware
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              icon: const Icon(
                Icons.memory,
                color: Colors.white,
              ),
              label: const Text(
                'Diagnóstico Hardware',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // Feature de permisos
                await Permission.camera.request();

                // Feature de Platform Channels
                const platform = MethodChannel(
                  'meditrack.com/battery',
                );

                try {
                  final int batteryLevel =
                      await platform.invokeMethod('getBatteryLevel');

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Batería del dispositivo: $batteryLevel%',
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                } on PlatformException catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No se pudo obtener el nivel de batería.',
                        ),
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 16),

            // Botón para exportar PDF
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
              label: const Text(
                'Exportar Historia Clínica',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final pdf = pw.Document();

                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) => pw.Center(
                      child: pw.Text(
                        'Historia Clínica - MediTrack\n\nPaciente: Activo\nEstado: Estable',
                        style: const pw.TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ),
                );

                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdf.save(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
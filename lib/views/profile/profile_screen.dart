import 'package:flutter/material.dart';
import 'package:meditrack_design_system/app_colors.dart';
import 'package:meditrack_design_system/app_typography.dart';
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
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Paciente Activo', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(userEmail, style: AppTypography.body),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()), 
                    (route) => false,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
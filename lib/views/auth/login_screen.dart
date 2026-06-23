import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditrack_design_system/design_system.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('MediTrack', style: AppTypography.titleLarge.copyWith(color: AppColors.primary)),
              SizedBox(height: 24.h),
              TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Usuario')),
              TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
              SizedBox(height: 24.h),
              Consumer<AuthViewModel>(
                builder: (context, auth, _) {
                  if (auth.isLoading) return const CircularProgressIndicator();
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    onPressed: () async {
                      final success = await auth.login(usernameCtrl.text, passwordCtrl.text);
                      if (success && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardScreen()),
                        );
                      }
                    },
                    child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
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
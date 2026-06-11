import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/design_system/design_system.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class AdherenceScreen extends StatelessWidget {
  const AdherenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Historial de Adherencia', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          final total = viewModel.medications.length;
          // Simulamos que el 80% se tomaron a tiempo para la demostración
          final tomadas = (total > 0) ? (total * 0.8).round() : 0;
          final porcentaje = total > 0 ? (tomadas / total) : 0.0;

          return Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                const Text('Progreso de Hoy', style: AppTypography.titleLarge),
                SizedBox(height: 40.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200.w,
                      height: 200.w,
                      child: CircularProgressIndicator(
                        value: porcentaje,
                        strokeWidth: 20.w,
                        backgroundColor: AppColors.primaryLight,
                        color: AppColors.success,
                      ),
                    ),
                    Text('${(porcentaje * 100).toInt()}%', style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(title: 'Tomadas', value: tomadas.toString(), color: AppColors.success),
                    _StatCard(title: 'Programadas', value: total.toString(), color: AppColors.primary),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12.r), 
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: AppTypography.body),
        ],
      ),
    );
  }
}
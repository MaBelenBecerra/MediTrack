import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/design_system/design_system.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

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
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          //Cargando
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          //Lista vacía
          if (viewModel.medications.isEmpty) {
            return Center(
              child: Text(
                'No tienes medicamentos programados hoy.',
                style: AppTypography.body,
              ),
            );
          }

          //Lista con datos
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
                    child: Icon(Icons.medication, color: AppColors.primary),
                  ),
                  title: Text(med.nombre, style: AppTypography.titleMedium),
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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pronto agregaremos medicamentos!')),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
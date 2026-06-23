import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'paciente@meditrack.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER CON DEGRADADO CORPORATIVO
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 80.h, bottom: 40.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF005088), Color(0xFF11CAA0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55.r,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60.sp, color: const Color(0xFF005088)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Paciente Activo',
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      userEmail,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30.h),

            // MENÚ DE OPCIONES
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuración de Sistema',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Botón Hardware
                  _buildProfileOption(
                    context,
                    icon: Icons.memory,
                    color: const Color(0xFF005088),
                    title: 'Diagnóstico de Hardware',
                    subtitle: 'Estado de batería y sensores nativos',
                    onTap: () {
                      // Lógica feature 9
                    },
                  ),

                  // Botón Exportar PDF
                  _buildProfileOption(
                    context,
                    icon: Icons.picture_as_pdf,
                    color: const Color(0xFF11CAA0),
                    title: 'Exportar Historia Clínica',
                    subtitle: 'Generar reporte de adherencia',
                    onTap: () {
                      // Lógica de exportación
                    },
                  ),

                  SizedBox(height: 24.h),
                  
                  // Botón Cerrar Sesión
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    color: Colors.redAccent,
                    title: 'Cerrar Sesión',
                    subtitle: 'Desconectar cuenta actual',
                    isDestructive: true,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {
    required IconData icon, 
    required Color color, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 16.sp, 
            fontWeight: FontWeight.bold, 
            color: isDestructive ? Colors.redAccent : const Color(0xFF1E293B)
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}
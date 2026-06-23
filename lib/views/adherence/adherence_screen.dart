import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdherenceScreen extends StatelessWidget {
  const AdherenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Historial', style: TextStyle(color: const Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0066FF), Color(0xFF11CAA0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [BoxShadow(color: const Color(0xFF0066FF).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Adherencia de\nesta semana',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70.w, height: 70.w,
                        child: CircularProgressIndicator(
                          value: 0.75, // 75% mockeado, conectado a ViewModel
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          color: Colors.white,
                          strokeWidth: 8,
                        ),
                      ),
                      Text('75%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            Text('Tus tomas', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
            SizedBox(height: 16.h),

            Expanded(
              child: ListView(
                children: [
                  _buildHistorialItem('Aspirina', 'Tomada a las 08:30 AM', const Color(0xFF11CAA0), true),
                  _buildHistorialItem('Vitamina C', 'Tomada a las 09:15 AM', const Color(0xFF0066FF), true),
                  _buildHistorialItem('Paracetamol', 'Omitida', Colors.red, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorialItem(String nombre, String estado, Color color, bool tomada) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.medication, color: color),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                SizedBox(height: 4.h),
                Text(estado, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Icon(tomada ? Icons.check_circle : Icons.cancel, color: color, size: 28.sp),
        ],
      ),
    );
  }
}
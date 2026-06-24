import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';                     
import 'package:pdf/widgets.dart' as pw;           
import 'package:printing/printing.dart';  

import '../auth/login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const platform = MethodChannel('com.meditrack/hardware');

  Future<void> _getBatteryLevel(BuildContext context) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔋 Diagnóstico Hardware (Web): Batería al 100% (Simulado)'),
          backgroundColor: Color(0xFF005088),
        ),
      );
      return;
    }

    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            title: const Row(
              children: [
                Icon(Icons.battery_charging_full, color: Color(0xFF005088)),
                SizedBox(width: 12.0),
                Expanded(child: Text('Diagnóstico de Hardware')),
              ],
            ),
            content: Text('Feature 9 ejecutada con éxito.\n\nEl porcentaje real de la batería de tu dispositivo es: $result%'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error del canal nativo: ${e.message}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _exportarPdf(BuildContext context, String userEmail) async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Generando documento PDF...'), backgroundColor: Color(0xFF11CAA0)),
    // );

    // Generamos el diseño del PDF usando los widgets de la librería 'pdf' (pw)
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header del PDF
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('MediTrack', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: const PdfColor(0, 0.31, 0.53))), // 0xFF005088
                  pw.Text('Reporte Oficial', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey)),
                ],
              ),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              
              // Datos del Paciente
              pw.Text('HISTORIA CLÍNICA Y ADHERENCIA', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Paciente: María Belén Becerra', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('Correo electrónico: $userEmail', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('Fecha de emisión: ${DateTime.now().toString().split(' ')[0]}', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 30),

              // Resumen de Adherencia
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: const PdfColor(0.95, 0.96, 0.98),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Adherencia de esta semana:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('75% (Aceptable)', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: const PdfColor(0.06, 0.79, 0.62))), // 0xFF11CAA0
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Tabla de registros
              pw.Text('Detalle de Tomas Recientes:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColor(0, 0.31, 0.53)),
                data: const <List<String>>[
                  <String>['Medicamento', 'Dosis', 'Estado', 'Fecha'],
                  <String>['Vitamina C', '1 tableta', 'Tomada', 'Hoy, 08:00 AM'],
                  <String>['Aspirina', '500mg', 'Tomada', 'Hoy, 02:00 PM'],
                  <String>['Paracetamol', '1 pastilla', 'Omitida', 'Ayer, 09:00 PM'],
                ],
              ),

              pw.Spacer(),
              pw.Center(
                child: pw.Text('Documento generado automáticamente por MediTrack System.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              )
            ],
          );
        },
      ),
    );

    // Muestra la vista de previsualización / impresión nativa del navegador en Web
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Historia_Clinica_MediTrack.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'becerrariveramariabelen@gmail.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF005088), Color(0xFF11CAA0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12.0, offset: const Offset(0, 6))
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 55.0, color: Color(0xFF005088)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('María Belén Becerra', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20.0)),
                    child: Text(userEmail, style: const TextStyle(fontSize: 13.0, color: Colors.white)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configuración de Sistema', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  const SizedBox(height: 16.0),
                  
                  _buildProfileOption(
                    context,
                    icon: Icons.memory,
                    color: const Color(0xFF005088),
                    title: 'Diagnóstico de Hardware',
                    subtitle: 'Estado de batería y sensores nativos',
                    onTap: () => _getBatteryLevel(context),
                  ),

                  // 🔥 AQUÍ CONECTAMOS LA LLAMADA AL PDF
                  _buildProfileOption(
                    context,
                    icon: Icons.picture_as_pdf,
                    color: const Color(0xFF11CAA0),
                    title: 'Exportar Historia Clínica',
                    subtitle: 'Generar reporte de adherencia',
                    onTap: () => _exportarPdf(context, userEmail),
                  ),

                  const SizedBox(height: 20.0),
                  
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    color: Colors.redAccent,
                    title: 'Cerrar Sesión',
                    subtitle: 'Desconectar cuenta actual',
                    isDestructive: true,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                      }
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

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required Color color, required String title, required String subtitle, required VoidCallback onTap, bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.0, offset: const Offset(0, 4))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        leading: Container(padding: const EdgeInsets.all(10.0), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 22.0)),
        title: Text(title, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: isDestructive ? Colors.redAccent : const Color(0xFF1E293B))),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black26),
        onTap: onTap,
      ),
    );
  }
}
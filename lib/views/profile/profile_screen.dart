import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'becerrariveramariabelen@gmail.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner superior curvo con degradado
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
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15), 
                          blurRadius: 12.0, 
                          offset: const Offset(0, 6)
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 55.0, color: Color(0xFF005088)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'María Belén Becerra',
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      userEmail,
                      style: const TextStyle(fontSize: 13.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30.0),

            // Tarjetas de opciones de las Features nativas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuración de Sistema',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16.0),
                  
                  _buildProfileOption(
                    context,
                    icon: Icons.memory,
                    color: const Color(0xFF005088),
                    title: 'Diagnóstico de Hardware',
                    subtitle: 'Estado de batería y sensores nativos',
                    onTap: () {},
                  ),

                  _buildProfileOption(
                    context,
                    icon: Icons.picture_as_pdf,
                    color: const Color(0xFF11CAA0),
                    title: 'Exportar Historia Clínica',
                    subtitle: 'Generar reporte de adherencia',
                    onTap: () {},
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
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02), 
            blurRadius: 10.0, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22.0),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 15.0, 
            fontWeight: FontWeight.bold, 
            color: isDestructive ? Colors.redAccent : const Color(0xFF1E293B)
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14.0, color: Colors.black26),
        onTap: onTap,
      ),
    );
  }
}
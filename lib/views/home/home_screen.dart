import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';   

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SearchScreen(), 
    const ProfileScreen(),   
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: isWeb ? const Color(0xFFE2E8F0) : Colors.white,
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isWeb ? 420 : double.infinity),
              margin: EdgeInsets.symmetric(vertical: isWeb ? 24.0 : 0),
              decoration: isWeb ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ) : null,
              child: ClipRRect(
                borderRadius: isWeb ? BorderRadius.circular(30) : BorderRadius.zero,
                child: Scaffold(
                  body: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    selectedItemColor: const Color(0xFF11CAA0),
                    unselectedItemColor: Colors.grey.shade400,
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.medication_liquid), label: 'Mis Pastillas'),
                      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar API'),
                      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
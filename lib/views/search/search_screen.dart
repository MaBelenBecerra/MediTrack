import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrack_design_system/app_colors.dart';
import 'package:meditrack_design_system/app_typography.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Dio _dio = Dio();
  List<dynamic> _resultados = [];
  bool _isLoading = false;

  Future<void> _buscar(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    
    try {
      final response = await _dio.get('https://api.fda.gov/drug/label.json?search=openfda.brand_name:$query&limit=5');
      
      if (!mounted) return;
      
      setState(() {
        _resultados = response.data['results'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron resultados'), 
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Buscar Prospecto (API)'), backgroundColor: AppColors.primary),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: _buscar,
              decoration: InputDecoration(
                hintText: 'Ej: Tylenol, Advil...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final item = _resultados[index];
                final brandName = item['openfda']?['brand_name']?[0] ?? 'Desconocido';
                final purpose = item['purpose']?[0] ?? 'Sin descripción';
                return ListTile(
                  leading: const Icon(
                    Icons.medical_information, 
                    color: AppColors.primary,
                  ),
                  title: Text(brandName, style: AppTypography.body),
                  subtitle: Text(purpose, maxLines: 2, overflow: TextOverflow.ellipsis),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
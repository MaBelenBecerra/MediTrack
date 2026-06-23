import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Lista simulada del resultado de la API de la FDA
  final List<Map<String, String>> _results = [
    {'name': 'Ibuprofen Dye Free', 'desc': 'Purpose Pain reliever/fever reducer'},
    {'name': 'Care One Ibuprofen', 'desc': 'Purposes Pain reliever/fever reducer'},
    {'name': 'Ibuprofen', 'desc': 'Sin descripción disponible'},
    {'name': 'Leader Ibuprofen', 'desc': 'Purposes Pain reliever/fever reducer'},
    {'name': 'Concentrated Ibuprofen Infants', 'desc': 'PURPOSE Pain reliever/fever reducer'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Buscar Prospecto (API)',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03), 
                    blurRadius: 10.0, 
                    offset: const Offset(0, 4)
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar en la base de datos FDA...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0066FF)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            
            // Lista de medicamentos encontrados
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02), 
                          blurRadius: 8.0, 
                          offset: const Offset(0, 2)
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(Icons.medical_information_outlined, color: Color(0xFF0066FF), size: 24.0),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item['desc']!,
                                style: TextStyle(fontSize: 13.0, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
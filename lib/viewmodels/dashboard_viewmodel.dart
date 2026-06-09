import 'package:flutter/material.dart';
import '../data/models/medication_model.dart';
import '../repositories/medication_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final MedicationRepository _repository;

  DashboardViewModel(this._repository);

  List<MedicationModel> _medications = [];
  bool _isLoading = false;

  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;

  Future<void> fetchMedications() async {
    _isLoading = true;
    notifyListeners(); // Le avisa a la pantalla que dibuje un "Cargando..."

    // En el repositorio a busca los datos
    _medications = await _repository.getMedications();

    _isLoading = false;
    notifyListeners();
  }
}
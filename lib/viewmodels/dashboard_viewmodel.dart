import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../core/utils/notification_helper.dart';
import '../data/models/medication_model.dart';
import '../repositories/medication_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final MedicationRepository _repository;

  DashboardViewModel(this._repository);

  // Estados privados
  List<MedicationModel> _medications = [];
  bool _isLoading = false;
  bool _isOffline = false;

  // Getters públicos para que la UI los lea
  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

  Future<void> fetchMedications() async {
    _isLoading = true;
    _isOffline = false;
    notifyListeners();

    try {
      _medications = await _repository.getMedications();
    } catch (e) {
      if (e.toString().contains('OFFLINE_MODE')) {
        _isOffline = true;
        // Obtenemos los datos de la caché local si no hay internet
        _medications = Hive.box('medications_box').values.cast<MedicationModel>().toList();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedication(MedicationModel medication) async {
    await _repository.addMedication(medication);
    await NotificationHelper.showNotification('¡Medicamento Guardado!', 'Registraste: ${medication.nombre}');
    await fetchMedications();
  }
}
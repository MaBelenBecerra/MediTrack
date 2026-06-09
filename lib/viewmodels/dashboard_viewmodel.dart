import 'package:flutter/foundation.dart';
import 'package:meditrack/core/errors/failures.dart';
import 'package:meditrack/data/models/medication_model.dart';
import 'package:meditrack/repositories/medication_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final MedicationRepository _repository;

  bool _isLoading = false;
  List<MedicationModel> _medications = [];
  Failure? _failure;
  bool _isFromCache = false;

  DashboardViewModel({required MedicationRepository repository})
      : _repository = repository;

  // Getters
  bool get isLoading => _isLoading;
  List<MedicationModel> get medications => _medications;
  Failure? get failure => _failure;
  bool get isFromCache => _isFromCache;
  int get medicationCount => _medications.length;
  String? get failureMessage => _failure?.message;

  /// Obtiene la lista de medicamentos desde el repositorio
  Future<void> fetchMedications() async {
    _setLoading(true);
    _failure = null;
    _isFromCache = false;

    try {
      final medications = await _repository.getMedications();
      _medications = medications;
      
      // Detectar si los datos vienen del caché
      if (medications.isEmpty && _repository.getCachedMedicationCount() == 0) {
        _isFromCache = false;
      } else if (_repository.getCachedMedicationCount() > 0) {
        _isFromCache = true;
      }
    } on ServerException catch (e) {
      _failure = e;
      print('❌ Error del servidor: ${e.message}');
    } on CacheException catch (e) {
      _failure = e;
      print('❌ Error del caché: ${e.message}');
    } on UnknownException catch (e) {
      _failure = e;
      print('❌ Error desconocido: ${e.message}');
    } catch (e) {
      _failure = UnknownException(
        message: 'Error inesperado: $e',
        exception: e as Exception?,
      );
      print('❌ Error no manejado: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Agregar un nuevo medicamento
  Future<bool> addMedication(MedicationModel medication) async {
    _setLoading(true);

    try {
      final success = await _repository.addMedication(medication);
      if (success) {
        await fetchMedications();
        return true;
      }
      _failure = UnknownException(
        message: 'No se pudo agregar el medicamento',
      );
      return false;
    } on ServerException catch (e) {
      _failure = e;
      print('❌ Error del servidor: ${e.message}');
      return false;
    } on CacheException catch (e) {
      _failure = e;
      print('⚠️ Error del caché: ${e.message}');
      // Retornar true si se agregó a la API aunque falle el caché
      return true;
    } catch (e) {
      _failure = UnknownException(
        message: 'Error al agregar medicamento: $e',
        exception: e as Exception?,
      );
      print('❌ Error no manejado: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Eliminar un medicamento
  Future<bool> deleteMedication(String medicationId) async {
    _setLoading(true);

    try {
      final success = await _repository.deleteMedication(medicationId);
      if (success) {
        _medications.removeWhere((med) => med.id == medicationId);
        notifyListeners();
        return true;
      }
      return false;
    } on ServerException catch (e) {
      _failure = e;
      print('❌ Error del servidor: ${e.message}');
      return false;
    } on CacheException catch (e) {
      _failure = e;
      print('❌ Error del caché: ${e.message}');
      return false;
    } catch (e) {
      _failure = UnknownException(
        message: 'Error al eliminar medicamento: $e',
        exception: e as Exception?,
      );
      print('❌ Error no manejado: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refrescar la lista de medicamentos
  Future<void> refreshMedications() async {
    try {
      await _repository.clearCache();
      await fetchMedications();
    } on CacheException catch (e) {
      _failure = e;
      print('⚠️ Error al limpiar caché: ${e.message}');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Limpiar estado
  void clearState() {
    _medications = [];
    _failure = null;
    _isLoading = false;
    _isFromCache = false;
    notifyListeners();
  }

  /// Limpiar solo el error
  void clearError() {
    _failure = null;
    notifyListeners();
  }
}

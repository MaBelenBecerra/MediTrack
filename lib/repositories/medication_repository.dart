import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditrack/core/errors/failures.dart';
import 'package:meditrack/core/network/dio_client.dart';
import 'package:meditrack/data/models/medication_model.dart';

class MedicationRepository {
  final DioClient _dioClient;
  final Box<MedicationModel> _medicationBox;

  static const String _apiEndpoint = '/medications';

  MedicationRepository({
    required DioClient dioClient,
    required Box<MedicationModel> medicationBox,
  })  : _dioClient = dioClient,
        _medicationBox = medicationBox;

  /// Obtiene medicamentos desde API con fallback a caché
  /// Lanza [ServerException] si falla la API y no hay caché
  /// Lanza [CacheException] si falla tanto API como caché
  Future<List<MedicationModel>> getMedications() async {
    try {
      // Intenta obtener datos de la API
      final response = await _dioClient.dio.get(_apiEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final medications = data
            .map((json) => MedicationModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Guarda en caché para uso offline
        await _saveMedicationsToCache(medications);

        return medications;
      } else {
        throw ServerException(
          message: 'Error en la API: Status ${response.statusCode}',
          statusCode: response.statusCode,
          response: response.data.toString(),
        );
      }
    } on DioException catch (e) {
      print('⚠️ Error de Dio: ${e.message}');
      // Intenta obtener del caché en caso de error de red
      return _getMedicationsFromCache();
    } on ServerException catch (e) {
      print('⚠️ Error del servidor: ${e.message}');
      // Intenta obtener del caché si la API falla
      return _getMedicationsFromCache();
    } catch (e) {
      print('❌ Error inesperado: $e');
      throw UnknownException(
        message: 'Error inesperado al obtener medicamentos: $e',
        exception: e as Exception?,
      );
    }
  }

  /// Guarda medicamentos en caché local
  Future<void> _saveMedicationsToCache(List<MedicationModel> medications) async {
    try {
      await _medicationBox.clear();
      for (var medication in medications) {
        await _medicationBox.add(medication);
      }
      print('✅ Medicamentos guardados en caché');
    } on HiveError catch (e) {
      throw CacheException(
        message: 'Error al guardar medicamentos en caché: ${e.message}',
        errorCode: 'HIVE_SAVE_ERROR',
      );
    } catch (e) {
      throw CacheException(
        message: 'Error desconocido al guardar en caché: $e',
        errorCode: 'UNKNOWN_CACHE_ERROR',
      );
    }
  }

  /// Obtiene medicamentos del caché local
  List<MedicationModel> _getMedicationsFromCache() {
    try {
      if (_medicationBox.isEmpty) {
        print('⚠️ Caché vacío, retornando lista vacía');
        return [];
      }

      final cachedMedications = _medicationBox.values.toList();
      print('✅ Medicamentos obtenidos del caché (${cachedMedications.length})');
      return cachedMedications;
    } on HiveError catch (e) {
      throw CacheException(
        message: 'Error al leer medicamentos del caché: ${e.message}',
        errorCode: 'HIVE_READ_ERROR',
      );
    } catch (e) {
      throw CacheException(
        message: 'Error desconocido al leer del caché: $e',
        errorCode: 'UNKNOWN_CACHE_ERROR',
      );
    }
  }

  /// Agregar un nuevo medicamento
  /// Lanza [ServerException] si falla la API
  /// Lanza [CacheException] si falla el caché
  Future<bool> addMedication(MedicationModel medication) async {
    try {
      final response = await _dioClient.dio.post(
        _apiEndpoint,
        data: medication.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Actualiza caché
        try {
          await _medicationBox.add(medication);
          print('✅ Medicamento agregado correctamente');
          return true;
        } catch (e) {
          throw CacheException(
            message: 'Medicamento agregado a la API pero no se guardó en caché: $e',
            errorCode: 'CACHE_SAVE_ERROR',
          );
        }
      } else {
        throw ServerException(
          message: 'Error al agregar medicamento: Status ${response.statusCode}',
          statusCode: response.statusCode,
          response: response.data.toString(),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'Error de red al agregar medicamento: ${e.message}',
        statusCode: e.response?.statusCode,
        response: e.response?.data.toString(),
      );
    } on ServerException {
      rethrow;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error inesperado al agregar medicamento: $e',
        exception: e as Exception?,
      );
    }
  }

  /// Elimina un medicamento por ID
  Future<bool> deleteMedication(String medicationId) async {
    try {
      final response = await _dioClient.dio.delete('$_apiEndpoint/$medicationId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Elimina del caché
        try {
          final toDelete = _medicationBox.values
              .where((med) => med.id == medicationId)
              .toList();
          for (var med in toDelete) {
            await med.delete();
          }
          print('✅ Medicamento eliminado correctamente');
          return true;
        } catch (e) {
          throw CacheException(
            message: 'Medicamento eliminado de la API pero no del caché: $e',
            errorCode: 'CACHE_DELETE_ERROR',
          );
        }
      } else {
        throw ServerException(
          message: 'Error al eliminar medicamento: Status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: 'Error de red al eliminar medicamento: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Limpia el caché local
  Future<void> clearCache() async {
    try {
      await _medicationBox.clear();
      print('✅ Caché limpiado');
    } catch (e) {
      throw CacheException(
        message: 'Error al limpiar caché: $e',
        errorCode: 'CACHE_CLEAR_ERROR',
      );
    }
  }

  /// Obtiene el número de medicamentos en caché
  int getCachedMedicationCount() {
    return _medicationBox.length;
  }
}

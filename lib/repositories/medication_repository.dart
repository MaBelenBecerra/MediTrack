import 'package:hive/hive.dart';
import '../core/network/dio_client.dart';
import '../data/models/medication_model.dart';

class MedicationRepository {
  // Se obtiene el cliente HTTP Singleton y la caja de Hive
  final _dio = DioClient().dio;
  final _box = Hive.box('medications_box');

  Future<List<MedicationModel>> getMedications() async {
    try {
      final response = await _dio.get('/medicamentos');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final medications = data.map((e) => MedicationModel.fromJson(e)).toList();
        
        await _box.clear();
        await _box.addAll(medications);
        return medications;
      }
    } catch (e) {
      throw Exception('OFFLINE_MODE');
    }
    return _box.values.cast<MedicationModel>().toList();
  }
  // Nuevo método para enviar a la API y guardar localmente
  Future<void> addMedication(MedicationModel medication) async {
    try {
      //Intentamos enviar el POST a tu backend NestJS
      await _dio.post('/medicamentos', data: medication.toJson());
    } catch (e) {
      // Si falla (no hay internet o el server está caído), capturamos el error
      // El flujo continuará para guardarlo localmente y sincronizar después.
    }
    //Guardamos en la caché de Hive (modo offline)
    await _box.add(medication);
  }
}
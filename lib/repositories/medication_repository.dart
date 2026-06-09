import 'package:hive/hive.dart';
import '../core/network/dio_client.dart';
import '../data/models/medication_model.dart';

class MedicationRepository {
  // Se obtiene el cliente HTTP Singleton y la caja de Hive
  final _dio = DioClient().dio;
  final _box = Hive.box('medications_box');

  Future<List<MedicationModel>> getMedications() async {
    try {
      // Intenta obtener los datos de la API en NestJS
      final response = await _dio.get('/medicamentos');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final medications = data.map((e) => MedicationModel.fromJson(e)).toList();
        
        //Hay éxito, entonces limpiamos la caché vieja y guardamos los nuevos datos
        await _box.clear();
        await _box.addAll(medications);
        
        return medications;
      }
    } catch (e) {
      //Si no hay internet o el servidor de NestJS está apagado, atrapamos el error permitiendo que el código continúe para sacar los datos locales.
    }

    //Fallback retorna lo que haya guardado en la bd local
    return _box.values.cast<MedicationModel>().toList();
  }
  Future<void> addMedicationLocal(MedicationModel medication) async {
    await _box.add(medication);
  }
}
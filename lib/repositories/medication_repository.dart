import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../data/models/medication_model.dart';

class MedicationRepository {
  final CollectionReference _db = FirebaseFirestore.instance.collection('medicamentos');
  final Box _box = Hive.box('medications_box');

  Future<List<MedicationModel>> getMedications() async {
    try {
      //Intento traer de Firebase
      final querySnapshot = await _db.get();
      final List<MedicationModel> medications = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MedicationModel.fromJson({...data, 'id': doc.id});
      }).toList();

      //Guardo en caché (Hive)
      await _box.clear();
      await _box.addAll(medications);
      return medications;
    } catch (e) {
      //Si no hay internet, devuelvo caché
      return _box.values.cast<MedicationModel>().toList();
    }
  }

  Future<void> addMedication(MedicationModel medication) async {
    try {
      // Guardar en la nube
      await _db.add(medication.toJson());
    } catch (e) {
      // Manejo silencioso si falla la red
    }
    // Respaldo local inmediato
    await _box.add(medication);
  }
}
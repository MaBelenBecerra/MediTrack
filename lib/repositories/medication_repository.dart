import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:meditrack/data/models/medication_model.dart';

class MedicationRepository {
  // 1. Obtenemos la caja directamente de Hive aquí
  final Box<MedicationModel> _medicationBox = Hive.box<MedicationModel>('medications_box');
  final CollectionReference _db = FirebaseFirestore.instance.collection('medicamentos');

  // 2. Dejamos el constructor vacío para que tu main.dart no marque error
  MedicationRepository();

  Future<List<MedicationModel>> getMedications() async {
    try {
      //(Firestore)
      final querySnapshot = await _db.get();
      
      final List<MedicationModel> medications = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MedicationModel.fromJson({...data, 'id': doc.id});
      }).toList();

      //caché local (Hive)
      await _medicationBox.clear();
      await _medicationBox.addAll(medications);

      return medications;
    } catch (e) {
      // Corrección: Usamos debugPrint en lugar de print
      debugPrint('⚠️ Modo Offline activado: $e'); 
      
      //Fallback: no hay internet, devolvemos lo que hay en Hive
      if (_medicationBox.isEmpty) return [];
      return _medicationBox.values.toList();
    }
  }

  Future<bool> addMedication(MedicationModel medication) async {
    try {
      // Guardar en Firestore
      final docRef = await _db.add(medication.toJson());
      
      //Guardar en Hive con el ID real de Firebase
      final medWithId = MedicationModel.fromJson({...medication.toJson(), 'id': docRef.id});
      await _medicationBox.add(medWithId);
      return true;
    } catch (e) {
      debugPrint('⚠️ Error al subir a Firebase, guardando en local: $e');
      
      // Si falla Firebase, lo guardo al menos en local
      await _medicationBox.add(medication);
      return true; 
    }
  }
}
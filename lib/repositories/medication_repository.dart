import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:meditrack/data/models/medication_model.dart';

class MedicationRepository {
  final Box<MedicationModel> _medicationBox =
      Hive.box<MedicationModel>('medications_box');

  MedicationRepository();

  CollectionReference get _db {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('medicamentos');
  }

  Future<List<MedicationModel>> getMedications() async {
    try {
      final querySnapshot = await _db.get();

      final List<MedicationModel> medications =
          querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MedicationModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();

      await _medicationBox.clear();
      await _medicationBox.addAll(medications);

      return medications;
    } catch (e) {
      debugPrint('Modo offline activado: $e');

      if (_medicationBox.isEmpty) return [];

      return _medicationBox.values.toList();
    }
  }

  Future<bool> addMedication(MedicationModel medication) async {
    try {
      final docRef = await _db.add(medication.toJson());

      final medWithId = MedicationModel.fromJson({
        ...medication.toJson(),
        'id': docRef.id,
      });

      await _medicationBox.add(medWithId);

      return true;
    } catch (e) {
      debugPrint('Error al subir a Firebase, guardando localmente: $e');

      await _medicationBox.add(medication);

      return true;
    }
  }
}
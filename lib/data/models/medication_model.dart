import 'package:hive/hive.dart';

part 'medication_model.g.dart';

@HiveType(typeId: 0)
class MedicationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nombre;

  @HiveField(2)
  final String dosis;

  @HiveField(3)
  final String hora;

  @HiveField(4)
  final String? imagePath;

  MedicationModel({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.hora,
    this.imagePath,
  });

  // Método para recibir datos desde la API (NestJS)
  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      dosis: json['dosis'] ?? '',
      hora: json['hora'] ?? '',
      imagePath: json['imagePath'],
    );
  }

  // Método para enviar datos a la API (NestJS)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'dosis': dosis,
      'hora': hora,
      'imagePath': imagePath,
    };
  }
}
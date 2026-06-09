import 'package:hive/hive.dart';

// NOTA: Descomenta esta línea después de ejecutar: flutter pub run build_runner build --delete-conflicting-outputs
// part 'medication_model.g.dart';

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

  MedicationModel({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.hora,
  });

  /// Convierte el JSON a una instancia de MedicationModel
  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      dosis: json['dosis'] as String? ?? '',
      hora: json['hora'] as String? ?? '',
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'dosis': dosis,
      'hora': hora,
    };
  }

  /// Método para copiar con cambios
  MedicationModel copyWith({
    String? id,
    String? nombre,
    String? dosis,
    String? hora,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      dosis: dosis ?? this.dosis,
      hora: hora ?? this.hora,
    );
  }

  @override
  String toString() {
    return 'MedicationModel(id: $id, nombre: $nombre, dosis: $dosis, hora: $hora)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicationModel &&
        other.id == id &&
        other.nombre == nombre &&
        other.dosis == dosis &&
        other.hora == hora;
  }

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ dosis.hashCode ^ hora.hashCode;
}

import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Emergencia - Botón de Pánico
class EmergencyModel {
  final String id;
  final String triggeredBy; // user_id
  final double locationLat;
  final double locationLng;
  final String type; // 'panic', 'medical', 'fire'
  final DateTime timestamp;
  final String status; // 'active', 'resolved'

  EmergencyModel({
    required this.id,
    required this.triggeredBy,
    required this.locationLat,
    required this.locationLng,
    required this.type,
    required this.timestamp,
    required this.status,
  });

  /// Crear desde documento de Firestore
  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: json['id'] as String,
      triggeredBy: json['triggered_by'] as String,
      locationLat: (json['location_lat'] as num).toDouble(),
      locationLng: (json['location_lng'] as num).toDouble(),
      type: json['type'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      status: json['status'] as String,
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'triggered_by': triggeredBy,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }

  /// Verificar si está activa
  bool get isActive => status == 'active';

  /// Verificar si está resuelta
  bool get isResolved => status == 'resolved';

  /// Obtener tipo en español
  String get typeName {
    switch (type) {
      case 'panic':
        return '🚨 Pánico';
      case 'medical':
        return '🏥 Médica';
      case 'fire':
        return '🔥 Incendio';
      default:
        return 'Emergencia';
    }
  }

  /// Obtener estado en español
  String get statusName {
    switch (status) {
      case 'active':
        return 'Activa';
      case 'resolved':
        return 'Resuelta';
      default:
        return 'Desconocido';
    }
  }

  EmergencyModel copyWith({
    String? id,
    String? triggeredBy,
    double? locationLat,
    double? locationLng,
    String? type,
    DateTime? timestamp,
    String? status,
  }) {
    return EmergencyModel(
      id: id ?? this.id,
      triggeredBy: triggeredBy ?? this.triggeredBy,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

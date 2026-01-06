import 'package:cloud_firestore/cloud_firestore.dart';

/// Punto de ruta para tracking GPS
class RoutePoint {
  final double lat;
  final double lng;
  final DateTime timestamp;

  RoutePoint({
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

/// Modelo de Recorrido de Guardia - GPS Tracking
class GuardPatrolModel {
  final String id;
  final String guardId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<RoutePoint> routePoints;

  GuardPatrolModel({
    required this.id,
    required this.guardId,
    required this.startTime,
    this.endTime,
    required this.routePoints,
  });

  /// Crear desde documento de Firestore
  factory GuardPatrolModel.fromJson(Map<String, dynamic> json) {
    return GuardPatrolModel(
      id: json['id'] as String,
      guardId: json['guard_id'] as String,
      startTime: (json['start_time'] as Timestamp).toDate(),
      endTime: json['end_time'] != null
          ? (json['end_time'] as Timestamp).toDate()
          : null,
      routePoints: (json['route_points'] as List<dynamic>?)
              ?.map((point) => RoutePoint.fromJson(point as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guard_id': guardId,
      'start_time': Timestamp.fromDate(startTime),
      'end_time': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'route_points': routePoints.map((point) => point.toJson()).toList(),
    };
  }

  /// Verificar si el recorrido está en progreso
  bool get isInProgress => endTime == null;

  /// Obtener duración del recorrido
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Obtener duración formateada
  String get durationFormatted {
    final d = duration;
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours h $minutes min';
    }
    return '$minutes min';
  }

  GuardPatrolModel copyWith({
    String? id,
    String? guardId,
    DateTime? startTime,
    DateTime? endTime,
    List<RoutePoint>? routePoints,
  }) {
    return GuardPatrolModel(
      id: id ?? this.id,
      guardId: guardId ?? this.guardId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      routePoints: routePoints ?? this.routePoints,
    );
  }
}

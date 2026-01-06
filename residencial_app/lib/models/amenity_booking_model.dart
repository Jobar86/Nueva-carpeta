/// Modelo de Reserva de Amenidades - Gym, Pool, Salón de Eventos
class AmenityBookingModel {
  final String id;
  final String amenityName;
  final String reservedBy; // user_id
  final String date; // YYYY-MM-DD
  final String timeSlot; // Ej: '10:00-12:00'
  final String status; // 'confirmed', 'cancelled'

  AmenityBookingModel({
    required this.id,
    required this.amenityName,
    required this.reservedBy,
    required this.date,
    required this.timeSlot,
    required this.status,
  });

  /// Crear desde documento de Firestore
  factory AmenityBookingModel.fromJson(Map<String, dynamic> json) {
    return AmenityBookingModel(
      id: json['id'] as String,
      amenityName: json['amenity_name'] as String,
      reservedBy: json['reserved_by'] as String,
      date: json['date'] as String,
      timeSlot: json['time_slot'] as String,
      status: json['status'] as String,
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amenity_name': amenityName,
      'reserved_by': reservedBy,
      'date': date,
      'time_slot': timeSlot,
      'status': status,
    };
  }

  /// Verificar si está confirmada
  bool get isConfirmed => status == 'confirmed';

  /// Verificar si está cancelada
  bool get isCancelled => status == 'cancelled';

  /// Obtener estado en español
  String get statusName {
    switch (status) {
      case 'confirmed':
        return 'Confirmada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return 'Pendiente';
    }
  }

  /// Obtener nombre de amenidad en español
  String get amenityDisplayName {
    switch (amenityName.toLowerCase()) {
      case 'gym':
        return 'Gimnasio';
      case 'pool':
        return 'Alberca';
      case 'event_hall':
        return 'Salón de Eventos';
      case 'bbq':
        return 'Área de Asadores';
      default:
        return amenityName;
    }
  }

  AmenityBookingModel copyWith({
    String? id,
    String? amenityName,
    String? reservedBy,
    String? date,
    String? timeSlot,
    String? status,
  }) {
    return AmenityBookingModel(
      id: id ?? this.id,
      amenityName: amenityName ?? this.amenityName,
      reservedBy: reservedBy ?? this.reservedBy,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
    );
  }
}

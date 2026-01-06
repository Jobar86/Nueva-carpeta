import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Invitación de Acceso - Códigos QR para visitantes
class AccessInvitationModel {
  final String id;
  final String hostId; // Residente que genera la invitación
  final String guestName;
  final String accessType; // 'visit', 'service', 'delivery'
  final String qrCodeHash;
  final DateTime validFrom;
  final DateTime validUntil;
  final String status; // 'active', 'used', 'expired'
  final DateTime? entryTime;

  AccessInvitationModel({
    required this.id,
    required this.hostId,
    required this.guestName,
    required this.accessType,
    required this.qrCodeHash,
    required this.validFrom,
    required this.validUntil,
    required this.status,
    this.entryTime,
  });

  /// Crear desde documento de Firestore
  factory AccessInvitationModel.fromJson(Map<String, dynamic> json) {
    return AccessInvitationModel(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      guestName: json['guest_name'] as String,
      accessType: json['access_type'] as String,
      qrCodeHash: json['qr_code_hash'] as String,
      validFrom: (json['valid_from'] as Timestamp).toDate(),
      validUntil: (json['valid_until'] as Timestamp).toDate(),
      status: json['status'] as String,
      entryTime: json['entry_time'] != null
          ? (json['entry_time'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host_id': hostId,
      'guest_name': guestName,
      'access_type': accessType,
      'qr_code_hash': qrCodeHash,
      'valid_from': Timestamp.fromDate(validFrom),
      'valid_until': Timestamp.fromDate(validUntil),
      'status': status,
      'entry_time': entryTime != null ? Timestamp.fromDate(entryTime!) : null,
    };
  }

  /// Verificar si la invitación está vigente
  bool get isValid {
    final now = DateTime.now();
    return status == 'active' && 
           now.isAfter(validFrom) && 
           now.isBefore(validUntil);
  }

  /// Obtener tipo de acceso en español
  String get accessTypeName {
    switch (accessType) {
      case 'visit':
        return 'Visita';
      case 'service':
        return 'Servicio';
      case 'delivery':
        return 'Paquetería';
      default:
        return 'Otro';
    }
  }

  /// Obtener estado en español
  String get statusName {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'used':
        return 'Utilizado';
      case 'expired':
        return 'Expirado';
      default:
        return 'Desconocido';
    }
  }

  AccessInvitationModel copyWith({
    String? id,
    String? hostId,
    String? guestName,
    String? accessType,
    String? qrCodeHash,
    DateTime? validFrom,
    DateTime? validUntil,
    String? status,
    DateTime? entryTime,
  }) {
    return AccessInvitationModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      guestName: guestName ?? this.guestName,
      accessType: accessType ?? this.accessType,
      qrCodeHash: qrCodeHash ?? this.qrCodeHash,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      entryTime: entryTime ?? this.entryTime,
    );
  }
}

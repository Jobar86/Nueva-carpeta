import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Usuario - Residentes, Guardias y Administradores
class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String role; // 'resident', 'guard', 'admin'
  final String? propertyId;
  final String? fcmToken;
  final bool isActive;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.propertyId,
    this.fcmToken,
    required this.isActive,
    required this.createdAt,
  });

  /// Crear desde documento de Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      propertyId: json['property_id'] as String?,
      fcmToken: json['fcm_token'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
      'role': role,
      'property_id': propertyId,
      'fcm_token': fcmToken,
      'is_active': isActive,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  /// Obtener nombre del rol en español
  String get roleName {
    switch (role) {
      case 'resident':
        return 'Residente';
      case 'guard':
        return 'Guardia';
      case 'admin':
        return 'Administrador';
      default:
        return 'Usuario';
    }
  }

  /// Verificar si es administrador
  bool get isAdmin => role == 'admin';

  /// Verificar si es guardia
  bool get isGuard => role == 'guard';

  /// Verificar si es residente
  bool get isResident => role == 'resident';

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? role,
    String? propertyId,
    String? fcmToken,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      propertyId: propertyId ?? this.propertyId,
      fcmToken: fcmToken ?? this.fcmToken,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

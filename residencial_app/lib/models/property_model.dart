/// Modelo de Propiedad - Casa o departamento
class PropertyModel {
  final String id;
  final String addressLabel; // Ej: 'Cluster 1, Casa 24'
  final String ownerId;
  final double currentBalance; // Positivo = crédito, Negativo = deuda
  final String status; // 'solvent', 'debtor'

  PropertyModel({
    required this.id,
    required this.addressLabel,
    required this.ownerId,
    required this.currentBalance,
    required this.status,
  });

  /// Crear desde documento de Firestore
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      addressLabel: json['address_label'] as String,
      ownerId: json['owner_id'] as String,
      currentBalance: (json['current_balance'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_label': addressLabel,
      'owner_id': ownerId,
      'current_balance': currentBalance,
      'status': status,
    };
  }

  /// Verificar si está al corriente
  bool get isSolvent => status == 'solvent';

  /// Verificar si es moroso
  bool get isDebtor => status == 'debtor';

  /// Obtener estado en español
  String get statusName {
    switch (status) {
      case 'solvent':
        return 'Al corriente';
      case 'debtor':
        return 'Moroso';
      default:
        return 'Desconocido';
    }
  }

  PropertyModel copyWith({
    String? id,
    String? addressLabel,
    String? ownerId,
    double? currentBalance,
    String? status,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      addressLabel: addressLabel ?? this.addressLabel,
      ownerId: ownerId ?? this.ownerId,
      currentBalance: currentBalance ?? this.currentBalance,
      status: status ?? this.status,
    );
  }
}

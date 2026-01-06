/// Modelo de Incidente - Reportes de mantenimiento
class IncidentModel {
  final String id;
  final String reportedBy;
  final String category; // 'maintenance', 'security', 'noise'
  final String description;
  final String? photoUrl;
  final String status; // 'open', 'in_progress', 'closed'

  IncidentModel({
    required this.id,
    required this.reportedBy,
    required this.category,
    required this.description,
    this.photoUrl,
    required this.status,
  });

  /// Crear desde documento de Firestore
  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String,
      reportedBy: json['reported_by'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      photoUrl: json['photo_url'] as String?,
      status: json['status'] as String,
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reported_by': reportedBy,
      'category': category,
      'description': description,
      'photo_url': photoUrl,
      'status': status,
    };
  }

  /// Obtener categoría en español
  String get categoryName {
    switch (category) {
      case 'maintenance':
        return 'Mantenimiento';
      case 'security':
        return 'Seguridad';
      case 'noise':
        return 'Ruido';
      default:
        return 'Otro';
    }
  }

  /// Obtener estado en español
  String get statusName {
    switch (status) {
      case 'open':
        return 'Abierto';
      case 'in_progress':
        return 'En Progreso';
      case 'closed':
        return 'Cerrado';
      default:
        return 'Desconocido';
    }
  }

  /// Obtener ícono de categoría
  String get categoryIcon {
    switch (category) {
      case 'maintenance':
        return '🔧';
      case 'security':
        return '🔒';
      case 'noise':
        return '🔊';
      default:
        return '📋';
    }
  }

  /// Verificar si está abierto
  bool get isOpen => status == 'open';

  /// Verificar si está en progreso
  bool get isInProgress => status == 'in_progress';

  /// Verificar si está cerrado
  bool get isClosed => status == 'closed';

  IncidentModel copyWith({
    String? id,
    String? reportedBy,
    String? category,
    String? description,
    String? photoUrl,
    String? status,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      reportedBy: reportedBy ?? this.reportedBy,
      category: category ?? this.category,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
    );
  }
}

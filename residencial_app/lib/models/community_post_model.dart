import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Publicación Comunitaria - Anuncios y Encuestas
class CommunityPostModel {
  final String id;
  final String type; // 'announcement', 'survey'
  final String title;
  final String content;
  final String authorId;
  final DateTime timestamp;
  final String priority;

  final List<String>? surveyOptions;
  final Map<String, int>? votes; // user_id: option_index

  CommunityPostModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.authorId,
    required this.timestamp,
    this.priority = 'normal', // 'normal', 'high'
    this.surveyOptions,
    this.votes,
  });

  /// Crear desde documento de Firestore
  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      priority: json['priority'] as String? ?? 'normal',
      surveyOptions: json['survey_options'] != null
          ? List<String>.from(json['survey_options'] as List)
          : null,
      votes: json['votes'] != null
          ? Map<String, int>.from(json['votes'] as Map)
          : null,
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'content': content,
      'author_id': authorId,
      'timestamp': Timestamp.fromDate(timestamp),
      'priority': priority,
      'survey_options': surveyOptions,
      'votes': votes,
    };
  }

  /// Verificar si es anuncio
  bool get isAnnouncement => type == 'announcement';

  /// Verificar si es encuesta
  bool get isSurvey => type == 'survey';

  /// Obtener tipo en español
  String get typeName {
    switch (type) {
      case 'announcement':
        return 'Comunicado';
      case 'survey':
        return 'Encuesta';
      default:
        return 'Publicación';
    }
  }

  /// Obtener total de votos
  int get totalVotes => votes?.length ?? 0;

  /// Verificar si un usuario ya votó
  bool hasUserVoted(String userId) {
    return votes?.containsKey(userId) ?? false;
  }

  /// Obtener votos por opción
  Map<int, int> getVotesByOption() {
    final result = <int, int>{};
    if (votes == null || surveyOptions == null) return result;
    
    for (var i = 0; i < surveyOptions!.length; i++) {
      result[i] = 0;
    }
    
    votes!.forEach((userId, optionIndex) {
      result[optionIndex] = (result[optionIndex] ?? 0) + 1;
    });
    
    return result;
  }

  CommunityPostModel copyWith({
    String? id,
    String? type,
    String? title,
    String? content,
    String? authorId,
    DateTime? timestamp,
    String? priority,
    List<String>? surveyOptions,
    Map<String, int>? votes,
  }) {
    return CommunityPostModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      timestamp: timestamp ?? this.timestamp,
      priority: priority ?? this.priority,
      surveyOptions: surveyOptions ?? this.surveyOptions,
      votes: votes ?? this.votes,
    );
  }
}

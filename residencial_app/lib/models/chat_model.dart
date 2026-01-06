import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Mensaje individual
class MessageModel {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool read;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.read,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'] as String,
      text: json['text'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      read: json['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'read': read,
    };
  }
}

/// Modelo de Chat - Conversación entre Residente y Caseta
class ChatModel {
  final String id; // Usualmente residentID_guardID
  final List<String> participants;
  final String lastMessage;
  final DateTime lastUpdated;

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastUpdated,
  });

  /// Crear desde documento de Firestore
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      participants: List<String>.from(json['participants'] as List),
      lastMessage: json['last_message'] as String? ?? '',
      lastUpdated: (json['last_updated'] as Timestamp).toDate(),
    );
  }

  /// Convertir a JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'last_message': lastMessage,
      'last_updated': Timestamp.fromDate(lastUpdated),
    };
  }

  /// Obtener el otro participante
  String getOtherParticipant(String currentUserId) {
    return participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  ChatModel copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastUpdated,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../models/community_post_model.dart';
import '../models/user_model.dart';

class CommunicationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Chats ---

  /// Obtener todos los chats relevantes para el usuario
  Stream<List<ChatModel>> getChats(String userId, String role) {
    Query query = _firestore.collection('chats');

    if (role == 'resident') {
      // Residentes ven solo sus chats (donde están en participantes)
      query = query.where('participants', arrayContains: userId);
    } else if (role == 'guard') {
      // Guardias ven todos los chats
      // Nota: En un sistema real, filtraríamos por "asignados" o todos los de residentes.
      // Por ahora, asumimos que ven todos los chats de soporte/seguridad.
      query = query.orderBy('last_updated', descending: true);
    } else {
       // Admins también ven todo
       query = query.orderBy('last_updated', descending: true);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Obtener mensajes de un chat específico
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();
    });
  }

  /// Enviar un mensaje
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final messagesRef = chatRef.collection('messages');

      final message = MessageModel(
        senderId: senderId,
        text: text,
        timestamp: DateTime.now(),
        read: false,
      );

      // Usar batch para asegurar consistencia
      final batch = _firestore.batch();
      
      // 1. Añadir mensaje a subcolección
      final msgDoc = messagesRef.doc();
      batch.set(msgDoc, message.toJson());

      // 2. Actualizar último mensaje en el chat padre
      batch.update(chatRef, {
        'last_message': text,
        'last_updated': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      print('Error enviando mensaje: $e');
      rethrow;
    }
  }

  /// Iniciar o obtener chat con Caseta (para residentes)
  Future<String> getOrCreateSupportChat(String residentId) async {
    // ID convencional: residentId_guardia
    // Pero como los guardias son un rol, mejor usamos un ID único para el chat del residente
    // Asumimos 1 chat principal por residente con "Administración/Seguridad"
    final chatId = residentId; 
    
    final doc = await _firestore.collection('chats').doc(chatId).get();
    
    if (!doc.exists) {
      // Crear chat si no existe
      final chat = ChatModel(
        id: chatId,
        participants: [residentId, 'GUARD_ROLE'], // 'GUARD_ROLE' es un placeholder para cualquier guardia
        lastMessage: 'Chat iniciado',
        lastUpdated: DateTime.now(),
      );
      await _firestore.collection('chats').doc(chatId).set(chat.toJson());
    }
    
    return chatId;
  }

  // --- Community Posts (Anuncios) ---

  /// Obtener feed de noticias
  Stream<List<CommunityPostModel>> getPosts() {
    return _firestore
        .collection('community_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommunityPostModel.fromJson(doc.data());
      }).toList();
    });
  }

  /// Crear una publicación (Solo Admin)
  Future<void> createPost(String title, String content, String authorId, String priority, {String type = 'announcement'}) async {
    try {
      final docRef = _firestore.collection('community_posts').doc();
      final post = CommunityPostModel(
        id: docRef.id,
        type: type,
        title: title,
        content: content,
        authorId: authorId,
        timestamp: DateTime.now(),
        priority: priority,
      );

      await docRef.set(post.toJson());
    } catch (e) {
      print('Error creando publicación: $e');
      rethrow;
    }
  }

  // --- Alerts (Trash Truck) ---

  /// Enviar alerta de camión de basura (Simulado)
  Future<void> triggerTrashAlert(String guardId) async {
    try {
      // En un sistema real, esto podría ser una Cloud Function.
      // Aquí escribimos en una colección 'notifications' que la app podría escuchar,
      // o simplemente confiamos en que al crear este documento, una Cloud Function (si existiera) dispararía el FCM.
      
      await _firestore.collection('notifications').add({
        'type': 'trash_truck',
        'title': '¡Llegó el camión de la basura!',
        'body': 'El camión recolector está ingresando al residencial.',
        'triggered_by': guardId,
        'timestamp': FieldValue.serverTimestamp(),
        'target_topic': 'all_residents',
      });
      
      print('Alerta de basura enviada');
    } catch (e) {
      print('Error enviando alerta de basura: $e');
      rethrow;
    }
  }
}

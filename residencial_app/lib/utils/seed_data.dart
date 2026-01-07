import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/property_model.dart';
import '../models/access_invitation_model.dart';
import '../models/chat_model.dart';
import '../models/community_post_model.dart';
import '../models/emergency_model.dart';

class SeedData {
  static Future<void> populateFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    print('🌱 Start seeding data...');

    // 1. Users & Properties
    final users = [
      // Admin
      UserModel(
        uid: 'admin_user_id',
        fullName: 'Admin User',
        email: 'admin@residential.app',
        role: 'admin',
        isActive: true,
        createdAt: DateTime.now(),
      ),
      // Guard
      UserModel(
        uid: 'guard_user_id',
        fullName: 'Security Guard',
        email: 'guard@residential.app',
        role: 'guard',
        isActive: true,
        createdAt: DateTime.now(),
      ),
    ];

    // Residents
    for (int i = 1; i <= 5; i++) {
      final propertyId = 'property_0$i';
      
      // Create Property
      final propertyRef = firestore.collection('properties').doc(propertyId);
      final property = PropertyModel(
        id: propertyId,
        addressLabel: 'Cluster A, House $i',
        ownerId: 'resident_0${i}_id',
        currentBalance: i == 2 ? -500.0 : 0.0, // Resident 2 is debtor
        status: i == 2 ? 'debtor' : 'solvent',
      );
      batch.set(propertyRef, property.toJson());

      // Create Resident User
      users.add(UserModel(
        uid: 'resident_0${i}_id',
        fullName: 'Resident $i',
        email: 'resident$i@residential.app',
        role: 'resident',
        propertyId: propertyId,
        isActive: true,
        createdAt: DateTime.now(),
      ));
    }

    // Batch write users
    for (var user in users) {
      final userRef = firestore.collection('users').doc(user.uid);
      batch.set(userRef, user.toJson());
    }

    // 2. Access Invitations (2 Active)
    final invitations = [
      AccessInvitationModel(
        id: 'invitation_01',
        hostId: 'resident_01_id', // Resident 1
        guestName: 'John Doe',
        accessType: 'visit',
        qrCodeHash: 'hash_12345',
        validFrom: DateTime.now().subtract(const Duration(hours: 1)),
        validUntil: DateTime.now().add(const Duration(hours: 4)),
        status: 'active',
      ),
      AccessInvitationModel(
        id: 'invitation_02',
        hostId: 'resident_03_id', // Resident 3
        guestName: 'Uber Eats',
        accessType: 'delivery',
        qrCodeHash: 'hash_67890',
        validFrom: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(minutes: 30)),
        status: 'active',
      ),
    ];

    for (var invite in invitations) {
      final inviteRef = firestore.collection('access_invitations').doc(invite.id);
      batch.set(inviteRef, invite.toJson());
    }

    // 3. Chat (Resident 1 <-> Guard)
    final chatId = 'resident_01_id_guard_user_id';
    final chatRef = firestore.collection('chats').doc(chatId);
    
    final chat = ChatModel(
      id: chatId,
      participants: ['resident_01_id', 'guard_user_id'],
      lastMessage: 'Ok, gracias.',
      lastUpdated: DateTime.now(),
    );
    batch.set(chatRef, chat.toJson());

    // Messages
    final messages = [
      MessageModel(
        senderId: 'resident_01_id',
        text: 'Hola, tengo una visita en camino.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        read: true,
      ),
      MessageModel(
        senderId: 'guard_user_id',
        text: 'Enterado, ¿cuál es el nombre?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        read: true,
      ),
      MessageModel(
        senderId: 'resident_01_id',
        text: 'Juan Pérez',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        read: true,
      ),
    ];

    for (var i = 0; i < messages.length; i++) {
        final msgRef = chatRef.collection('messages').doc('msg_0$i');
        batch.set(msgRef, messages[i].toJson());
    }

    // 4. Panic Alert (1 Active)
    final emergencyRef = firestore.collection('emergencies').doc('emergency_01');
    final emergency = EmergencyModel(
        id: 'emergency_01',
        triggeredBy: 'resident_04_id',
        type: 'medical',
        status: 'active',
        timestamp: DateTime.now(),
        locationLat: 19.4326,
        locationLng: -99.1332,
    );
    batch.set(emergencyRef, emergency.toJson());

    // 5. Community Announcements
    final posts = [
      CommunityPostModel(
        id: 'post_01',
        type: 'announcement',
        title: 'Corte de Agua',
        content: 'Habrá mantenimiento en la bomba de agua mañana de 10am a 2pm.',
        authorId: 'admin_user_id',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CommunityPostModel(
        id: 'post_02',
        type: 'announcement',
        title: 'Reunión Vecinal',
        content: 'Recordatorio: Reunión mensual este sábado en la casa club.',
        authorId: 'admin_user_id',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    for (var post in posts) {
      final postRef = firestore.collection('community_posts').doc(post.id);
      batch.set(postRef, post.toJson());
    }

    try {
      await batch.commit();
      print('✅ Seeding completed successfully!');
    } catch (e) {
      print('❌ Error seeding data: $e');
    }
  }
}

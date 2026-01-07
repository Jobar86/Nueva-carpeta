import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/communication_service.dart';
import '../../models/chat_model.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final communicationService = Provider.of<CommunicationService>(context, listen: false);
    
    // Check if user is authenticated and data is loaded
    if (authService.userId == null || authService.userRole == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final isGuard = authService.isGuard || authService.isAdmin;

    return StreamBuilder<List<ChatModel>>(
      stream: communicationService.getChats(authService.userId!, authService.userRole!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = snapshot.data!;

        if (chats.isEmpty) {
          // Si es Residente y no tiene chats, mostrar botón para iniciar soporte
          if (!isGuard) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 60, color: AppTheme.textLight),
                  const SizedBox(height: 16),
                  const Text('No tienes mensajes', style: AppTextStyles.heading2),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final chatId = await communicationService.getOrCreateSupportChat(authService.userId!);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: chatId,
                              otherUserName: 'Seguridad', // Nombre genérico
                              otherUserId: 'GUARD_ROLE',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.headset_mic),
                    label: const Text('Contactar Seguridad'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay mensajes recientes'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return _ChatTile(chat: chat, currentUserId: authService.userId!, isGuard: isGuard);
          },
        );
      },
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatModel chat;
  final String currentUserId;
  final bool isGuard;

  const _ChatTile({required this.chat, required this.currentUserId, required this.isGuard});

  @override
  Widget build(BuildContext context) {
    final lastDate = DateFormat('HH:mm').format(chat.lastUpdated);
    
    // Si soy guardia, el "otro" es el Residente (cuyo ID es el del chat usualmente)
    // En este MVP simple, asumimos IDs directos o nombres dummy.
    // Para mostrar el nombre real, necesitaríamos buscar el usuario en Firestore.
    // Hack MVP: Usar el ID como nombre o "Residente"
    String displayName = 'Usuario';
    if (isGuard) {
       // El ID del chat es el ID del residente en nuestro esquema 'residentId'
       // Podríamos hacer un FutureBuilder aquí para sacar el nombre, pero por rapidez:
       displayName = 'Vecino'; // O chat.id si quieres ver el ID
    } else {
      displayName = 'Caseta de Seguridad';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isGuard ? Colors.orange : AppTheme.primaryColor,
          child: Icon(
            isGuard ? Icons.person : Icons.security,
            color: Colors.white,
          ),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySecondary,
        ),
        trailing: Text(lastDate, style: AppTextStyles.caption),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                chatId: chat.id,
                otherUserName: displayName,
                otherUserId: chat.getOtherParticipant(currentUserId),
              ),
            ),
          );
        },
      ),
    );
  }
}

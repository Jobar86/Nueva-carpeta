import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Hub de Comunicación - Chat y Comunicados
class CommunicationHubScreen extends StatelessWidget {
  const CommunicationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Comunicación',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textLight,
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Chat'),
              Tab(text: 'Comunicados'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatTab(context),
            _buildAnnouncementsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildChatItem(
          context,
          name: 'Caseta de Seguridad',
          lastMessage: 'Tu visita ha llegado',
          time: '10:30',
          unread: 2,
          isOnline: true,
        ),
        _buildChatItem(
          context,
          name: 'Administración',
          lastMessage: 'Tu pago ha sido registrado',
          time: 'Ayer',
          unread: 0,
          isOnline: false,
        ),
      ],
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String lastMessage,
    required String time,
    required int unread,
    required bool isOnline,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(
                Icons.security_rounded,
                color: Colors.white,
              ),
            ),
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          lastMessage,
          style: AppTextStyles.bodySecondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time, style: AppTextStyles.caption),
            if (unread > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unread',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chat con $name'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAnnouncementCard(
          title: '🚰 Mantenimiento de Agua',
          content: 'Se suspenderá el servicio de agua mañana de 9:00 a 14:00 hrs por mantenimiento programado.',
          author: 'Administración',
          time: 'Hace 2 horas',
          isPinned: true,
        ),
        _buildAnnouncementCard(
          title: '🎄 Posada Comunitaria',
          content: 'Los invitamos a la posada navideña este sábado a las 18:00 hrs en el salón de eventos.',
          author: 'Comité Social',
          time: 'Hace 1 día',
          isPinned: false,
        ),
        _buildAnnouncementCard(
          title: '🗳️ Nueva Encuesta',
          content: '¿Qué horario prefieres para la limpieza de áreas comunes?',
          author: 'Administración',
          time: 'Hace 2 días',
          isPinned: false,
          isSurvey: true,
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String content,
    required String author,
    required String time,
    bool isPinned = false,
    bool isSurvey = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
        border: isPinned
            ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isPinned) ...[
                Icon(Icons.push_pin, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
              ],
              if (isSurvey) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ENCUESTA',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppTheme.textLight),
              const SizedBox(width: 4),
              Text(author, style: AppTextStyles.caption),
              const Spacer(),
              Text(time, style: AppTextStyles.caption),
            ],
          ),
          if (isSurvey) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.how_to_vote, size: 18),
                  SizedBox(width: 8),
                  Text('Votar'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';
import 'chat_list_screen.dart';
import 'feed_screen.dart';

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
    return const ChatListScreen();
  }


  Widget _buildAnnouncementsTab(BuildContext context) {
    return const FeedScreen();
  }

}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/communication_service.dart';
import '../../models/community_post_model.dart';
import 'post_create_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final communicationService = Provider.of<CommunicationService>(context);
    final isAdmin = authService.isAdmin;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: StreamBuilder<List<CommunityPostModel>>(
        stream: communicationService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.campaign_outlined, size: 60, color: AppTheme.textLight),
                  const SizedBox(height: 16),
                  const Text('No hay comunicados', style: AppTextStyles.heading2),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _PostCard(post: posts[index]);
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostCreateScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Anuncio'),
            )
          : null,
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPostModel post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final timeDisplay = _formatTime(post.timestamp);
    final isHighPriority = post.priority == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
        border: isHighPriority
            ? Border.all(color: AppTheme.dangerColor.withOpacity(0.5), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               if (isHighPriority) ...[
                const Icon(Icons.error_outline, size: 20, color: AppTheme.dangerColor),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: post.isAnnouncement ? Colors.blue.withOpacity(0.1) : Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  post.typeName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: post.isAnnouncement ? Colors.blue : Colors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppTheme.textLight),
              const SizedBox(width: 4),
              const Text('Administración', style: AppTextStyles.caption), // Simplificado
              const Spacer(),
              Text(timeDisplay, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 24) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours} horas';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }
}

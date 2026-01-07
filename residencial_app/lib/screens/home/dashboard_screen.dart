import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/communication_service.dart';
import '../../widgets/widgets.dart';
import '../../widgets/panic_button_widget.dart';
import '../security/invitation_create_screen.dart';
import '../security/patrol_map_screen.dart';
import '../communication/chat_list_screen.dart';
import '../communication/feed_screen.dart';

/// Pantalla principal del Dashboard
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con saludo
              DashboardHeader(
                userName: authService.userName ?? 'Usuario',
                userRole: _getRoleName(authService.userRole),
                onProfileTap: () => _navigateTo(context, '/profile'),
                onNotificationTap: () => _showNotifications(context),
              ),
              
              const SizedBox(height: 8),
              
              // Tarjeta de acceso rápido principal (Botón de Pánico)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QuickAccessCardLarge(
                  icon: Icons.warning_amber_rounded,
                  title: 'Botón de Pánico',
                  subtitle: 'Alertar a vecinos y caseta',
                  gradient: AppTheme.dangerGradient,
                  onTap: () => _navigateTo(context, '/panic-button'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección: Acceso y Seguridad
              _buildSectionTitle('Acceso y Seguridad'),
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: [
                    QuickAccessCard(
                      icon: Icons.qr_code_2,
                      label: 'Registro de\nVisitas',
                      color: AppTheme.primaryColor,
                      onTap: () => _navigateTo(context, '/access-control'),
                    ),
                    QuickAccessCard(
                      icon: Icons.door_sliding_outlined,
                      label: 'Ábrete\nSésamo',
                      color: AppTheme.successColor,
                      onTap: () => _navigateTo(context, '/gate-opener'),
                    ),
                    QuickAccessCard(
                      icon: Icons.location_on,
                      label: 'Recorridos',
                      color: AppTheme.accentColor,
                      onTap: () => _navigateTo(context, '/guard-patrol'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección: Comunicación
              _buildSectionTitle('Comunicación'),
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: [
                    QuickAccessCard(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat con\nCaseta',
                      color: AppTheme.primaryLight,
                      onTap: () => _navigateTo(context, '/chat'),
                      showBadge: true,
                      badgeText: '2',
                    ),
                    QuickAccessCard(
                      icon: Icons.campaign_outlined,
                      label: 'Comunicados',
                      color: AppTheme.warningColor,
                      onTap: () => _navigateTo(context, '/announcements'),
                    ),
                    QuickAccessCard(
                      icon: Icons.delete_outline,
                      label: 'La Basura',
                      color: Colors.brown,
                      onTap: () => _navigateTo(context, '/trash-alert'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección: Administración
              _buildSectionTitle('Administración'),
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: [
                    QuickAccessCard(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Pagos y\nTransparencia',
                      color: AppTheme.successColor,
                      onTap: () => _navigateTo(context, '/transparency'),
                    ),
                    QuickAccessCard(
                      icon: Icons.receipt_long_outlined,
                      label: 'Morosidad',
                      color: AppTheme.dangerColor,
                      onTap: () => _navigateTo(context, '/debt-control'),
                    ),
                    QuickAccessCard(
                      icon: Icons.how_to_vote_outlined,
                      label: 'Encuestas',
                      color: AppTheme.accentColor,
                      onTap: () => _navigateTo(context, '/surveys'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección: Servicios
              _buildSectionTitle('Servicios'),
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: [
                    QuickAccessCard(
                      icon: Icons.calendar_month_outlined,
                      label: 'Reservar\nAmenidades',
                      color: AppTheme.primaryColor,
                      onTap: () => _navigateTo(context, '/booking'),
                    ),
                    QuickAccessCard(
                      icon: Icons.report_problem_outlined,
                      label: 'Reportar\nIncidencia',
                      color: AppTheme.warningColor,
                      onTap: () => _navigateTo(context, '/incident-report'),
                    ),
                    QuickAccessCard(
                      icon: Icons.badge_outlined,
                      label: 'Mi Credencial\nDigital',
                      gradient: AppTheme.primaryGradient,
                      onTap: () => _navigateTo(context, '/digital-id'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.heading3,
          ),
        ],
      ),
    );
  }

  String _getRoleName(String? role) {
    switch (role) {
      case 'resident':
        return 'Residente';
      case 'guard':
        return 'Guardia de Seguridad';
      case 'admin':
        return 'Administrador';
      default:
        return 'Usuario';
    }
  }

  void _navigateTo(BuildContext context, String route) {
    Widget? screen;
    
    switch (route) {
      case '/panic-button':
        _showPanicDialog(context);
        return;
      case '/access-control':
        screen = const InvitationCreateScreen();
        break;
      case '/gate-opener':
        // Simular apertura de puerta
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚪 Puerta abierta por 30 segundos'),
            backgroundColor: Colors.green,
          ),
        );
        return;
      case '/guard-patrol':
        screen = const PatrolMapScreen();
        break;
      case '/chat':
        screen = const ChatListScreen();
        break;
      case '/announcements':
        screen = const FeedScreen();
        break;
      case '/trash-alert':
        _triggerTrashAlert(context);
        return;
      default:
        // Ruta no implementada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Función "$route" próximamente'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
    }
    
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
    }
  }

  void _showPanicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Botón de Pánico'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mantén presionado el botón para activar la alerta de emergencia.'),
            const SizedBox(height: 20),
            PanicButtonWidget(size: 200),
          ],
        ),
      ),
    );
  }

  void _triggerTrashAlert(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    if (!authService.isGuard && !authService.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo guardias pueden enviar esta alerta'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚛 ¿Confirmar Alerta de Basura?'),
        content: const Text('Esto notificará a todos los residentes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enviar')),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final commService = Provider.of<CommunicationService>(context, listen: false);
      await commService.triggerTrashAlert(authService.userId!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Alerta enviada a residentes'), backgroundColor: Colors.green),
        );
      }
    }
  }


  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Notificaciones',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: Icons.campaign,
              title: 'Nuevo comunicado',
              subtitle: 'Mantenimiento de agua mañana',
              time: 'Hace 2 horas',
            ),
            _buildNotificationItem(
              icon: Icons.person,
              title: 'Visita registrada',
              subtitle: 'María González ingresó',
              time: 'Hace 4 horas',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

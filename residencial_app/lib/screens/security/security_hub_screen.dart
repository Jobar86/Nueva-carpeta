import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/security_service.dart';
import '../../widgets/widgets.dart';
import '../../services/panic_service.dart';
import '../../services/communication_service.dart';
import 'invitation_create_screen.dart';
import 'qr_scanner_screen.dart';
import 'patrol_map_screen.dart';
import '../../widgets/panic_button_widget.dart';

/// Hub de Seguridad - Lista de funciones de seguridad
class SecurityHubScreen extends StatelessWidget {
  const SecurityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Seguridad'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de emergencia
            QuickAccessCardLarge(
              icon: Icons.warning_amber_rounded,
              title: 'Botón de Pánico',
              subtitle: 'Alertar emergencia a todos',
              gradient: AppTheme.dangerGradient,
              onTap: () => _showPanicDialog(context),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de funciones
            // 2. Registro de Visitas (Todos)
            _buildSecurityOption(
              context,
              title: 'Registro de Visitas',
              subtitle: 'Generar códigos QR para visitantes',
              icon: Icons.qr_code_2,
              color: Colors.indigo,
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InvitationCreateScreen()),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 3. Control de Acceso (Solo Guardia/Admin)
            if (authService.isGuard || authService.isAdmin)
              _buildSecurityOption(
                context,
                title: 'Escanear QR',
                subtitle: 'Validar entradas y salidas',
                icon: Icons.qr_code_scanner,
                color: Colors.purple,
                isGuardOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                  );
                },
              ),

            if (authService.isGuard || authService.isAdmin)
              const SizedBox(height: 16),
            
            // 4. Apertura Remota (Todos)
            _buildSecurityOption(
              context,
              title: 'Ábrete Sésamo',
              subtitle: 'Abrir portón principal',
              icon: Icons.door_front_door,
              color: Colors.teal,
              onTap: () async {
                  final securityService = Provider.of<SecurityService>(context, listen: false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enviando señal de apertura...')),
                  );
                  final success = await securityService.triggerGateOpen();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(success ? 'Portón Abierto Correctamente' : 'Error al abrir portón'),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
              },
            ),

            const SizedBox(height: 16),
            
            _buildSecurityOption(
              context,
              icon: Icons.route_rounded,
              title: 'Recorridos',
              subtitle: 'Ver ubicación del guardia en tiempo real',
              color: AppTheme.primaryLight,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatrolMapScreen()),
                );
              },
            ),
            
            const SizedBox(height: 16),

            // 6. Alerta de Servicios (Solo Guardia/Admin) - Camión de Basura
             if (authService.isGuard || authService.isAdmin)
              _buildSecurityOption(
                context,
                icon: Icons.delete_outline,
                title: 'Alerta de Basura',
                subtitle: 'Notificar llegada del camión',
                color: Colors.brown,
                isGuardOnly: true,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('¿Confirmar Alerta?'),
                      content: const Text('Esto notificará a TODOS los residentes que el camión de basura ha llegado.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enviar Notificación')),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                     final commService = Provider.of<CommunicationService>(context, listen: false); // Requires Import if not present, but SecurityHub might not have CommService imported yet.
                     // IMPORTANT: I need to check imports in SecurityHubScreen.
                     // Assuming I will add it.
                     await commService.triggerTrashAlert(authService.userId!);
                     if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Notificación enviada a los residentes'), backgroundColor: Colors.green),
                       );
                     }
                  }
                },
              ),
            
            const SizedBox(height: 16),

            _buildSecurityOption(
              context,
              icon: Icons.history_rounded,
              title: 'Historial de Accesos',
              subtitle: 'Consulta quién ha ingresado',
              color: AppTheme.warningColor,
              onTap: () => _navigateTo(context, 'Historial de Accesos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
    bool isGuardOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0), // Margin handled by SizedBox in parent
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (isGuardOnly) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Guardia',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySecondary,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.textLight,
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateTo(BuildContext context, String screen) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando a: $screen'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showPanicDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              PanicButtonWidget(size: 250),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Mantén presionado por 3 segundos\npara enviar alerta de emergencia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
             const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

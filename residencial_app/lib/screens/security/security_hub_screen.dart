import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Hub de Seguridad - Lista de funciones de seguridad
class SecurityHubScreen extends StatelessWidget {
  const SecurityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              onTap: () => _navigateTo(context, 'Botón de Pánico'),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de funciones
            _buildSecurityOption(
              context,
              icon: Icons.qr_code_2_rounded,
              title: 'Registro de Visitas',
              subtitle: 'Genera códigos QR para tus invitados',
              color: AppTheme.primaryColor,
            ),
            
            _buildSecurityOption(
              context,
              icon: Icons.door_sliding_rounded,
              title: 'Ábrete Sésamo',
              subtitle: 'Abre la puerta principal remotamente',
              color: AppTheme.successColor,
            ),
            
            _buildSecurityOption(
              context,
              icon: Icons.qr_code_scanner_rounded,
              title: 'Escanear QR',
              subtitle: 'Validar acceso de visitantes',
              color: AppTheme.accentColor,
              isGuardOnly: true,
            ),
            
            _buildSecurityOption(
              context,
              icon: Icons.route_rounded,
              title: 'Recorridos',
              subtitle: 'Ver ubicación del guardia en tiempo real',
              color: AppTheme.primaryLight,
            ),
            
            _buildSecurityOption(
              context,
              icon: Icons.history_rounded,
              title: 'Historial de Accesos',
              subtitle: 'Consulta quién ha ingresado',
              color: AppTheme.warningColor,
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
    bool isGuardOnly = false,
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
        onTap: () => _navigateTo(context, title),
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
}

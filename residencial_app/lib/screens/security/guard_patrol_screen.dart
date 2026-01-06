import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Pantalla de Recorridos del Guardia - GPS Tracking
class GuardPatrolScreen extends StatefulWidget {
  const GuardPatrolScreen({super.key});

  @override
  State<GuardPatrolScreen> createState() => _GuardPatrolScreenState();
}

class _GuardPatrolScreenState extends State<GuardPatrolScreen> {
  bool _isPatrolActive = false;
  final DateTime _lastUpdate = DateTime.now();

  // Datos de ejemplo
  final List<Map<String, dynamic>> _patrolHistory = [
    {
      'date': 'Hoy, 10:30',
      'duration': '45 min',
      'guard': 'Carlos García',
      'status': 'completed',
    },
    {
      'date': 'Hoy, 06:00',
      'duration': '1h 15min',
      'guard': 'Miguel Rodríguez',
      'status': 'completed',
    },
    {
      'date': 'Ayer, 22:00',
      'duration': '50 min',
      'guard': 'Carlos García',
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Recorridos',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado actual
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: _isPatrolActive
                    ? AppTheme.accentGradient
                    : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isPatrolActive
                              ? Icons.directions_walk
                              : Icons.location_off,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isPatrolActive
                                  ? 'Recorrido en Curso'
                                  : 'Sin Recorrido Activo',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isPatrolActive
                                  ? 'Carlos García • 15 min activo'
                                  : 'Último: hace 2 horas',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Indicador de estado
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isPatrolActive
                              ? AppTheme.successColor
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isPatrolActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isPatrolActive ? 'Activo' : 'Inactivo',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  if (_isPatrolActive) ...[
                    const SizedBox(height: 20),
                    // Mapa placeholder
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Mapa de Recorrido',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '(Integración con Google Maps)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Punto de ubicación simulado
                          Positioned(
                            top: 80,
                            left: 120,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentColor.withOpacity(0.4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Estadísticas del día
            const Text('Estadísticas de Hoy', style: AppTextStyles.label),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.route,
                    value: '3',
                    label: 'Recorridos',
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer,
                    value: '2h 50m',
                    label: 'Tiempo Total',
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    value: '100%',
                    label: 'Cobertura',
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Historial
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Historial de Recorridos', style: AppTextStyles.label),
                TextButton(
                  onPressed: () {},
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            ..._patrolHistory.map((patrol) => _buildPatrolItem(patrol)),
            
            const SizedBox(height: 24),
            
            // Información para guardias
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.warningColor),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Los guardias pueden iniciar recorridos desde la app con tracking GPS en tiempo real.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // FAB para guardias (iniciar recorrido)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _togglePatrol(),
        backgroundColor: _isPatrolActive ? AppTheme.dangerColor : AppTheme.successColor,
        icon: Icon(_isPatrolActive ? Icons.stop : Icons.play_arrow),
        label: Text(_isPatrolActive ? 'Detener' : 'Iniciar Recorrido'),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPatrolItem(Map<String, dynamic> patrol) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patrol['guard'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(patrol['date'], style: AppTextStyles.caption),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(patrol['duration'], style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Ver detalles del recorrido
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  void _togglePatrol() {
    setState(() {
      _isPatrolActive = !_isPatrolActive;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPatrolActive
              ? 'Recorrido iniciado - GPS activado'
              : 'Recorrido finalizado',
        ),
        backgroundColor: _isPatrolActive ? AppTheme.successColor : AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

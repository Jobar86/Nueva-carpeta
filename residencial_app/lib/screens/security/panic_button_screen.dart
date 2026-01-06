import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Pantalla de Botón de Pánico - Alerta de emergencia
class PanicButtonScreen extends StatefulWidget {
  const PanicButtonScreen({super.key});

  @override
  State<PanicButtonScreen> createState() => _PanicButtonScreenState();
}

class _PanicButtonScreenState extends State<PanicButtonScreen>
    with TickerProviderStateMixin {
  bool _isActivated = false;
  bool _isHolding = false;
  double _holdProgress = 0;
  String _selectedType = 'panic';
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _emergencyTypes = [
    {'value': 'panic', 'label': 'Pánico', 'icon': Icons.warning_amber, 'color': AppTheme.dangerColor},
    {'value': 'medical', 'label': 'Médica', 'icon': Icons.medical_services, 'color': Colors.blue},
    {'value': 'fire', 'label': 'Incendio', 'icon': Icons.local_fire_department, 'color': Colors.orange},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isActivated ? AppTheme.dangerColor : AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Botón de Pánico',
        showBackButton: !_isActivated,
      ),
      body: _isActivated ? _buildAlertActive() : _buildNormalState(),
    );
  }

  Widget _buildNormalState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Advertencia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.dangerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: AppTheme.dangerColor.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: AppTheme.dangerColor),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Usa este botón solo en caso de emergencia real. Se notificará a todos los vecinos y a la caseta de seguridad.',
                    style: TextStyle(
                      color: AppTheme.dangerColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Selector de tipo de emergencia
          const Text(
            'Tipo de emergencia',
            style: AppTextStyles.label,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: _emergencyTypes.map((type) {
              final isSelected = _selectedType == type['value'];
              final color = type['color'] as Color;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = type['value']),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: type != _emergencyTypes.last ? 12 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          type['icon'],
                          size: 32,
                          color: isSelected ? Colors.white : color,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type['label'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 48),
          
          // Botón de pánico
          const Text(
            'Mantén presionado para activar',
            style: AppTextStyles.bodySecondary,
          ),
          
          const SizedBox(height: 24),
          
          GestureDetector(
            onLongPressStart: (_) => _startHold(),
            onLongPressEnd: (_) => _endHold(),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isHolding ? 0.95 : _pulseAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: AppTheme.dangerGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.dangerColor.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progreso circular
                        if (_isHolding)
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: _holdProgress,
                              strokeWidth: 6,
                              color: Colors.white,
                              backgroundColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              size: 64,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isHolding ? 'Manteniendo...' : 'SOS',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Información adicional
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: AppTheme.softShadow,
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.people, 'Notificará a todos los vecinos'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.security, 'Alertará a la caseta de seguridad'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on, 'Enviará tu ubicación actual'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Text(text, style: AppTextStyles.bodySecondary),
      ],
    );
  }

  Widget _buildAlertActive() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animación de alerta
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_rounded,
              size: 100,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            '¡ALERTA ACTIVADA!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Se ha notificado a todos los vecinos\ny a la caseta de seguridad',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 48),
          
          // Botón cancelar
          OutlinedButton.icon(
            onPressed: _cancelAlert,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            icon: const Icon(Icons.cancel),
            label: const Text(
              'Cancelar Alerta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'La ayuda está en camino',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _startHold() {
    setState(() => _isHolding = true);
    HapticFeedback.mediumImpact();
    
    _updateHoldProgress();
  }

  Future<void> _updateHoldProgress() async {
    for (int i = 0; i <= 100; i += 5) {
      if (!_isHolding) break;
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (mounted && _isHolding) {
        setState(() => _holdProgress = i / 100);
        
        if (i == 100) {
          _activateAlert();
        }
      }
    }
  }

  void _endHold() {
    setState(() {
      _isHolding = false;
      _holdProgress = 0;
    });
  }

  void _activateAlert() {
    HapticFeedback.heavyImpact();
    
    setState(() {
      _isHolding = false;
      _isActivated = true;
    });
    
    // TODO: Enviar alerta real a Firebase/Backend
  }

  void _cancelAlert() {
    setState(() => _isActivated = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alerta cancelada'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}

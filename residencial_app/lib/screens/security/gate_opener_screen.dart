import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Pantalla "Ábrete Sésamo" - Control remoto de puerta
class GateOpenerScreen extends StatefulWidget {
  const GateOpenerScreen({super.key});

  @override
  State<GateOpenerScreen> createState() => _GateOpenerScreenState();
}

class _GateOpenerScreenState extends State<GateOpenerScreen>
    with SingleTickerProviderStateMixin {
  bool _isOpening = false;
  bool _isSuccess = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Ábrete Sésamo',
        showBackButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de puerta
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSuccess ? Icons.check_circle : Icons.door_sliding_outlined,
                  size: 80,
                  color: _isSuccess ? AppTheme.successColor : AppTheme.primaryColor,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                _isSuccess ? '¡Puerta Abierta!' : 'Puerta Principal',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                _isSuccess
                    ? 'La puerta se cerrará automáticamente'
                    : 'Presiona el botón para abrir',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Botón grande de apertura
              GestureDetector(
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) {
                  _animationController.reverse();
                  _openGate();
                },
                onTapCancel: () => _animationController.reverse(),
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: _isSuccess
                              ? const LinearGradient(
                                  colors: [AppTheme.successColor, Color(0xFF27AE60)],
                                )
                              : AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isSuccess
                                      ? AppTheme.successColor
                                      : AppTheme.primaryColor)
                                  .withOpacity(0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isOpening
                              ? const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 4,
                                  ),
                                )
                              : Icon(
                                  _isSuccess
                                      ? Icons.lock_open_rounded
                                      : Icons.touch_app_rounded,
                                  size: 64,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Historial rápido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.history, size: 20, color: AppTheme.textSecondary),
                        SizedBox(width: 8),
                        Text(
                          'Últimas aperturas',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildHistoryItem('Hoy, 10:30', 'Juan Pérez'),
                    _buildHistoryItem('Hoy, 08:15', 'Juan Pérez'),
                    _buildHistoryItem('Ayer, 19:45', 'Juan Pérez'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String time, String user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.door_sliding, size: 16, color: AppTheme.successColor),
          const SizedBox(width: 8),
          Text(time, style: AppTextStyles.caption),
          const Spacer(),
          Text(user, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Future<void> _openGate() async {
    if (_isOpening) return;
    
    setState(() => _isOpening = true);
    
    // TODO: Llamar al webhook IoT real
    // await http.post(Uri.parse('https://tu-webhook-iot.com/abrir'));
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isOpening = false;
      _isSuccess = true;
    });
    
    // Resetear después de unos segundos
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() => _isSuccess = false);
    }
  }
}

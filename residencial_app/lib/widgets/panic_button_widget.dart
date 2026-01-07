import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../config/app_theme.dart';
import '../services/auth_service.dart';
import '../services/panic_service.dart';

class PanicButtonWidget extends StatefulWidget {
  final double size;
  
  const PanicButtonWidget({
    super.key, 
    this.size = 200.0,
  });

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 3 segundos para activar
    );

    _controller.addListener(() {
      setState(() {
        _progress = _controller.value;
      });
      if (_controller.isCompleted) {
        _triggerPanic();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _reset();
  }

  void _onTapCancel() {
    _reset();
  }

  void _reset() {
    if (!_controller.isCompleted) {
      setState(() => _isPressed = false);
      _controller.reset();
    }
  }

  Future<void> _triggerPanic() async {
    // Feedback háptico
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500);
    }

    if (!mounted) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final panicService = Provider.of<PanicService>(context, listen: false);

    // Mostrar diálogo de carga/bloqueo
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
    );

    // Enviar alerta
    final success = await panicService.sendPanicAlert(
      userId: authService.userId ?? 'unknown',
    );

    if (!mounted) return;
    Navigator.pop(context); // Cerrar loader

    if (success) {
      _showSuccessDialog();
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar alerta. Intente de nuevo.')),
      );
      _reset();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('¡ALERTA ENVIADA!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Se ha enviado tu ubicación a la caseta de vigilancia y a tus vecinos.\n\nMantén la calma, la ayuda va en camino.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text('Entendido', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo pulsante (opcional, simplificado aquí)
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
            ),
          ),
          
          // Progreso circular
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          
          // Botón central
          Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _isPressed 
                  ? const LinearGradient(colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)])
                  : AppTheme.dangerGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: _isPressed ? 10 : 20,
                  spreadRadius: _isPressed ? 2 : 5,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: widget.size * 0.3,
                  color: Colors.white,
                ),
                if (_isPressed)
                  Text(
                    'Sostén para enviar',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  const Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

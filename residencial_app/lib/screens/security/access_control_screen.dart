import 'package:flutter/material.dart';
import 'dart:math';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Pantalla de Control de Acceso - Generar QR para visitas
class AccessControlScreen extends StatefulWidget {
  const AccessControlScreen({super.key});

  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  final _formKey = GlobalKey<FormState>();
  final _guestNameController = TextEditingController();
  String _selectedAccessType = 'visit';
  int _validHours = 4;
  bool _isGenerating = false;
  String? _generatedQrData;

  final List<Map<String, dynamic>> _accessTypes = [
    {'value': 'visit', 'label': 'Visita', 'icon': Icons.person},
    {'value': 'service', 'label': 'Servicio', 'icon': Icons.build},
    {'value': 'delivery', 'label': 'Paquetería', 'icon': Icons.local_shipping},
  ];

  @override
  void dispose() {
    _guestNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Registro de Visitas',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instrucciones
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.accentColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Genera un código QR temporal para que tu visita pueda ingresar',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Nombre del visitante
              const Text('Nombre del visitante', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _guestNameController,
                decoration: const InputDecoration(
                  hintText: 'Ej: María González',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del visitante';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Tipo de acceso
              const Text('Tipo de acceso', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Row(
                children: _accessTypes.map((type) {
                  final isSelected = _selectedAccessType == type['value'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAccessType = type['value'];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: type != _accessTypes.last ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade300,
                          ),
                          boxShadow: isSelected ? AppTheme.softShadow : null,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              type['icon'],
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Duración de validez
              const Text('Válido por', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_validHours > 1) {
                          setState(() => _validHours--);
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.remove, size: 20),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$_validHours',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const Text(
                            'horas',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_validHours < 24) {
                          setState(() => _validHours++);
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, size: 20, color: AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botón generar QR
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateQrCode,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.qr_code_2),
                  label: Text(_isGenerating ? 'Generando...' : 'Generar Código QR'),
                ),
              ),
              
              // QR generado
              if (_generatedQrData != null) ...[
                const SizedBox(height: 32),
                _buildQrResult(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrResult() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Código generado!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Para: ${_guestNameController.text}',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 24),
          
          // QR Placeholder (en producción usarías qr_flutter)
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: Icon(
                Icons.qr_code_2_rounded,
                size: 150,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Válido hasta: ${_getExpirationTime()}',
            style: AppTextStyles.caption,
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compartiendo...')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getExpirationTime() {
    final expiration = DateTime.now().add(Duration(hours: _validHours));
    return '${expiration.hour.toString().padLeft(2, '0')}:${expiration.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _generateQrCode() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isGenerating = true);
    
    // Simular generación
    await Future.delayed(const Duration(seconds: 1));
    
    // Generar hash único
    final random = Random();
    final hash = List.generate(8, (_) => random.nextInt(16).toRadixString(16)).join().toUpperCase();
    
    setState(() {
      _isGenerating = false;
      _generatedQrData = 'RES-$hash';
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Código QR generado exitosamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}

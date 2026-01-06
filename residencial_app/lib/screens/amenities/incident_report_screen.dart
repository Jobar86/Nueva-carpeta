import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Pantalla de Reporte de Incidencias
class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'maintenance';
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'value': 'maintenance',
      'label': 'Mantenimiento',
      'icon': Icons.build,
      'color': AppTheme.warningColor,
      'examples': 'Lámpara fundida, bache, tubería rota',
    },
    {
      'value': 'security',
      'label': 'Seguridad',
      'icon': Icons.shield,
      'color': AppTheme.dangerColor,
      'examples': 'Puerta dañada, cámara sin funcionar',
    },
    {
      'value': 'noise',
      'label': 'Ruido',
      'icon': Icons.volume_up,
      'color': AppTheme.accentColor,
      'examples': 'Fiesta ruidosa, construcción fuera de horario',
    },
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Reportar Incidencia',
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
              // Información
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tu reporte será enviado a administración para su seguimiento.',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Categoría
              const Text('Categoría', style: AppTextStyles.label),
              const SizedBox(height: 12),
              
              ...List.generate(_categories.length, (index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['value'];
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category['value']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? category['color'] : Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                        color: isSelected ? category['color'] : Colors.grey.shade200,
                        width: 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: (category['color'] as Color).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : category['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Icon(
                            category['icon'],
                            color: isSelected ? Colors.white : category['color'],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['label'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category['examples'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.8)
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.white),
                      ],
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: 24),
              
              // Descripción
              const Text('Descripción', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe el problema con detalle...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor describe el problema';
                  }
                  if (value.length < 10) {
                    return 'La descripción debe ser más detallada';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Foto
              const Text('Agregar foto (opcional)', style: AppTextStyles.label),
              const SizedBox(height: 8),
              
              GestureDetector(
                onTap: _addPhoto,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 40,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Toca para agregar foto',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botón enviar
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitReport,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isSubmitting ? 'Enviando...' : 'Enviar Reporte'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Mis reportes recientes
              const Text('Mis reportes recientes', style: AppTextStyles.label),
              const SizedBox(height: 12),
              
              _buildReportItem(
                category: 'maintenance',
                description: 'Lámpara fundida en calle 5',
                status: 'in_progress',
                date: 'Hace 2 días',
              ),
              _buildReportItem(
                category: 'noise',
                description: 'Ruido excesivo en casa 12',
                status: 'closed',
                date: 'Hace 1 semana',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem({
    required String category,
    required String description,
    required String status,
    required String date,
  }) {
    final categoryData = _categories.firstWhere((c) => c['value'] == category);
    
    final statusColors = {
      'open': AppTheme.warningColor,
      'in_progress': AppTheme.accentColor,
      'closed': AppTheme.successColor,
    };
    
    final statusNames = {
      'open': 'Abierto',
      'in_progress': 'En progreso',
      'closed': 'Cerrado',
    };

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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: categoryData['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              categoryData['icon'],
              color: categoryData['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(date, style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColors[status]!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusNames[status]!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColors[status],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo cámara...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    // Simular envío
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isSubmitting = false);
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successColor),
              SizedBox(width: 12),
              Text('Reporte Enviado'),
            ],
          ),
          content: const Text(
            'Tu reporte ha sido recibido. Te notificaremos cuando haya actualizaciones.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }
}

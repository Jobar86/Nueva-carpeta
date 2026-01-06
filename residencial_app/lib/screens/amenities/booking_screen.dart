import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/widgets.dart';

/// Pantalla de Reservas de Amenidades
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _selectedAmenity = 'gym';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;

  final List<Map<String, dynamic>> _amenities = [
    {'value': 'gym', 'label': 'Gimnasio', 'icon': Icons.fitness_center, 'color': AppTheme.primaryColor},
    {'value': 'pool', 'label': 'Alberca', 'icon': Icons.pool, 'color': AppTheme.accentColor},
    {'value': 'event_hall', 'label': 'Salón', 'icon': Icons.celebration, 'color': AppTheme.warningColor},
    {'value': 'bbq', 'label': 'Asadores', 'icon': Icons.outdoor_grill, 'color': Colors.brown},
  ];

  final List<String> _timeSlots = [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00',
    '20:00 - 22:00',
  ];

  // Simulación de slots ocupados
  final List<String> _occupiedSlots = ['10:00 - 12:00', '16:00 - 18:00'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Reservar Amenidades',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de amenidad
            const Text('Selecciona una amenidad', style: AppTextStyles.label),
            const SizedBox(height: 12),
            
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _amenities.length,
                itemBuilder: (context, index) {
                  final amenity = _amenities[index];
                  final isSelected = _selectedAmenity == amenity['value'];
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAmenity = amenity['value']),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? amenity['color'] : Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(
                          color: isSelected ? amenity['color'] : Colors.grey.shade200,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: (amenity['color'] as Color).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ] : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            amenity['icon'],
                            size: 32,
                            color: isSelected ? Colors.white : amenity['color'],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            amenity['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Selector de fecha
            const Text('Selecciona una fecha', style: AppTextStyles.label),
            const SizedBox(height: 12),
            
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14, // Próximos 14 días
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = _selectedDate.day == date.day &&
                      _selectedDate.month == date.month;
                  final isToday = index == 0;
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(date.weekday),
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white70 : AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                          if (isToday)
                            Text(
                              'Hoy',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.white70 : AppTheme.accentColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Selector de horario
            const Text('Selecciona un horario', style: AppTextStyles.label),
            const SizedBox(height: 12),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final slot = _timeSlots[index];
                final isOccupied = _occupiedSlots.contains(slot);
                final isSelected = _selectedTimeSlot == slot;
                
                return GestureDetector(
                  onTap: isOccupied ? null : () => setState(() => _selectedTimeSlot = slot),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOccupied
                          ? Colors.grey.shade100
                          : isSelected
                              ? AppTheme.primaryColor
                              : Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                        color: isOccupied
                            ? Colors.grey.shade300
                            : isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade200,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isOccupied ? Icons.block : Icons.access_time,
                            size: 18,
                            color: isOccupied
                                ? Colors.grey
                                : isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            slot,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isOccupied
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                              decoration: isOccupied ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Resumen y botón de reserva
            if (_selectedTimeSlot != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_available, color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getAmenityName(_selectedAmenity),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_formatDate(_selectedDate)} · $_selectedTimeSlot',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _confirmBooking,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Confirmar Reserva'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[weekday - 1];
  }

  String _getAmenityName(String value) {
    final amenity = _amenities.firstWhere((a) => a['value'] == value);
    return amenity['label'];
  }

  String _formatDate(DateTime date) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 
                    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _confirmBooking() {
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
            Text('Reserva Confirmada'),
          ],
        ),
        content: Text(
          '${_getAmenityName(_selectedAmenity)}\n${_formatDate(_selectedDate)} · $_selectedTimeSlot',
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

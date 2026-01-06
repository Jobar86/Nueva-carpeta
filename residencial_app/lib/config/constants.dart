/// Constantes de la aplicación
class AppConstants {
  // Nombre de la app
  static const String appName = 'Mi Residencial';
  static const String appVersion = '1.0.0';
  
  // Colecciones de Firestore
  static const String usersCollection = 'users';
  static const String propertiesCollection = 'properties';
  static const String accessInvitationsCollection = 'access_invitations';
  static const String amenityBookingsCollection = 'amenity_bookings';
  static const String emergenciesCollection = 'emergencies';
  static const String guardPatrolsCollection = 'guard_patrols';
  static const String chatsCollection = 'chats';
  static const String messagesSubcollection = 'messages';
  static const String communityPostsCollection = 'community_posts';
  static const String incidentsCollection = 'incidents';
  
  // Tipos de acceso
  static const List<String> accessTypes = ['visit', 'service', 'delivery'];
  static const Map<String, String> accessTypeNames = {
    'visit': 'Visita',
    'service': 'Servicio',
    'delivery': 'Paquetería',
  };
  
  // Tipos de emergencia
  static const List<String> emergencyTypes = ['panic', 'medical', 'fire'];
  static const Map<String, String> emergencyTypeNames = {
    'panic': 'Pánico',
    'medical': 'Médica',
    'fire': 'Incendio',
  };
  
  // Amenidades disponibles
  static const List<String> amenities = ['gym', 'pool', 'event_hall', 'bbq'];
  static const Map<String, String> amenityNames = {
    'gym': 'Gimnasio',
    'pool': 'Alberca',
    'event_hall': 'Salón de Eventos',
    'bbq': 'Área de Asadores',
  };
  
  // Categorías de incidencias
  static const List<String> incidentCategories = ['maintenance', 'security', 'noise'];
  static const Map<String, String> incidentCategoryNames = {
    'maintenance': 'Mantenimiento',
    'security': 'Seguridad',
    'noise': 'Ruido',
  };
  
  // Roles de usuario
  static const String roleResident = 'resident';
  static const String roleGuard = 'guard';
  static const String roleAdmin = 'admin';
  
  // Duración de QR por defecto (horas)
  static const int defaultQrValidityHours = 4;
  
  // Slots de tiempo para amenidades
  static const List<String> timeSlots = [
    '06:00-08:00',
    '08:00-10:00',
    '10:00-12:00',
    '12:00-14:00',
    '14:00-16:00',
    '16:00-18:00',
    '18:00-20:00',
    '20:00-22:00',
  ];
}

/// Rutas de la aplicación
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String accessControl = '/access-control';
  static const String gateOpener = '/gate-opener';
  static const String panicButton = '/panic-button';
  static const String guardPatrol = '/guard-patrol';
  static const String chat = '/chat';
  static const String announcements = '/announcements';
  static const String trashAlert = '/trash-alert';
  static const String transparency = '/transparency';
  static const String debtControl = '/debt-control';
  static const String surveys = '/surveys';
  static const String booking = '/booking';
  static const String incidentReport = '/incident-report';
  static const String digitalId = '/digital-id';
  static const String profile = '/profile';
}

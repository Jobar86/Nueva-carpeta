import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'config/app_theme.dart';
import 'services/auth_service.dart';
import 'services/security_service.dart';
import 'services/panic_service.dart';
import 'services/communication_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurar estilo de barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ResidencialApp());
}

/// Aplicación principal de Gestión Residencial
class ResidencialApp extends StatelessWidget {
  const ResidencialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SecurityService()),
        ChangeNotifierProvider(create: (_) => PanicService()),
        ChangeNotifierProvider(create: (_) => CommunicationService()),
      ],
      child: MaterialApp(
        title: 'Mi Residencial',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        
        // Configuración de idioma español
        locale: const Locale('es', 'MX'),
        
        // Pantalla inicial
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            // Si está autenticado, mostrar navegación principal
            if (authService.isAuthenticated) {
              return const MainNavigation();
            }
            // Si no, mostrar login
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

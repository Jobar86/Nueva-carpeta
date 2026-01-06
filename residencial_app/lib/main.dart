import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'services/auth_service.dart';
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
  
  // TODO: Inicializar Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
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

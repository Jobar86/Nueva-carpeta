import 'package:flutter/material.dart';

/// Servicio de Autenticación (Placeholder)
/// Conecta con Firebase Auth para gestionar usuarios
class AuthService extends ChangeNotifier {
  bool _isLoading = false;
  String? _userId;
  String? _userRole;
  String? _userName;
  String? _userEmail;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _userId != null;
  String? get userId => _userId;
  String? get userRole => _userRole;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  /// Iniciar sesión con email y contraseña
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar con Firebase Auth
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      
      // Simulación para desarrollo
      await Future.delayed(const Duration(seconds: 1));
      _userId = 'demo_user_123';
      _userRole = 'resident';
      _userName = 'Juan Pérez';
      _userEmail = email;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Registrar nuevo usuario
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar con Firebase Auth
      await Future.delayed(const Duration(seconds: 1));
      
      _userId = 'new_user_${DateTime.now().millisecondsSinceEpoch}';
      _userRole = role;
      _userName = fullName;
      _userEmail = email;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    // TODO: Implementar con Firebase Auth
    // await FirebaseAuth.instance.signOut();
    
    _userId = null;
    _userRole = null;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }

  /// Verificar si es administrador
  bool get isAdmin => _userRole == 'admin';

  /// Verificar si es guardia
  bool get isGuard => _userRole == 'guard';

  /// Verificar si es residente
  bool get isResident => _userRole == 'resident';

  /// Establecer usuario de demostración por rol
  void setDemoUser(String role) {
    _userId = 'demo_${role}_123';
    _userRole = role;
    
    switch (role) {
      case 'resident':
        _userName = 'Juan Pérez';
        _userEmail = 'residente@demo.com';
        break;
      case 'guard':
        _userName = 'Carlos García';
        _userEmail = 'guardia@demo.com';
        break;
      case 'admin':
        _userName = 'Ana López';
        _userEmail = 'admin@demo.com';
        break;
    }
    
    notifyListeners();
  }
}

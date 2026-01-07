import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Servicio de Autenticación con Firebase Auth
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  UserModel? _currentUserModel;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _auth.currentUser != null;
  String? get userId => _auth.currentUser?.uid;
  String? get userEmail => _auth.currentUser?.email;
  
  // Obtener datos del usuario desde el modelo
  String? get userRole => _currentUserModel?.role;
  String? get userName => _currentUserModel?.fullName;
  String? get propertyId => _currentUserModel?.propertyId;

  bool get isAdmin => userRole == 'admin';
  bool get isGuard => userRole == 'guard';
  bool get isResident => userRole == 'resident';

  AuthService() {
    // Escuchar cambios en el estado de autenticación
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _currentUserModel = null;
        notifyListeners();
      }
    });
  }

  /// Iniciar sesión con email y contraseña
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // _fetchUserData se llamará automáticamente por el listener
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error en login: ${e.code}');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Error general: $e');
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
    required String role, // 'resident', 'guard', 'admin'
    String? propertyId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Crear usuario en Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) throw Exception('No se pudo crear el usuario');

      // 2. Crear documento en Firestore
      final newUser = UserModel(
        uid: credential.user!.uid,
        fullName: fullName,
        email: email,
        role: role,
        propertyId: propertyId,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(newUser.uid).set(newUser.toJson());
      
      // Actualizar estado local
      _currentUserModel = newUser;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error en registro: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Obtener datos adicionales del usuario desde Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUserModel = UserModel.fromJson(doc.data()!);
        // Si el usuario no tiene rol en Firestore, asignar 'resident' por defecto para evitar nulls
        if (_currentUserModel?.role == null) {
             print("Advertencia: Usuario sin rol definido en Firestore.");
        }
      } else {
        print("Advertencia: Usuario autenticado pero sin documento en Firestore.");
      }
    } catch (e) {
      print("Error obteniendo datos del usuario: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUserModel = null;
    notifyListeners();
  }
}

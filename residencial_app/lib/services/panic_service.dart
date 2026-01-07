import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/emergency_model.dart';

class PanicService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Enviar alerta de pánico
  Future<bool> sendPanicAlert({required String userId}) async {
    try {
      // 1. Obtener ubicación actual
      final Position position = await _determinePosition();

      // 2. Crear documento de emergencia
      final docRef = _firestore.collection('emergencies').doc();
      
      final emergency = EmergencyModel(
        id: docRef.id,
        triggeredBy: userId,
        locationLat: position.latitude,
        locationLng: position.longitude,
        type: 'panic',
        timestamp: DateTime.now(),
        status: 'active',
      );

      await docRef.set(emergency.toJson());
      
      // TODO: Aquí se dispararía una Cloud Function para notificaciones push
      
      return true;
    } catch (e) {
      print('Error enviando alerta de pánico: $e');
      return false;
    }
  }

  /// Escuchar emergencias activas (Para el guardia/admin)
  Stream<List<EmergencyModel>> get activeEmergenciesStream {
    return _firestore
        .collection('emergencies')
        .where('status', isEqualTo: 'active')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EmergencyModel.fromJson(doc.data()))
          .toList();
    });
  }

  /// Resolver una emergencia
  Future<void> resolveEmergency(String emergencyId) async {
    await _firestore.collection('emergencies').doc(emergencyId).update({
      'status': 'resolved',
    });
  }

  // Helper para obtener ubicación con permisos
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Los permisos de ubicación están denegados permanentemente.');
    } 

    return await Geolocator.getCurrentPosition();
  }
}

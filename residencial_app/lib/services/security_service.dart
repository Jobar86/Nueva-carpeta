import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import '../models/access_invitation_model.dart';
import '../models/user_model.dart';

class SecurityService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crear una nueva invitación
  Future<AccessInvitationModel?> createInvitation({
    required String hostId,
    required String guestName,
    required String accessType,
    required DateTime validFrom,
    required DateTime validUntil,
  }) async {
    try {
      final docRef = _firestore.collection('access_invitations').doc();
      
      // Generar un hash único para el QR
      final rawString = '$hostId-$guestName-${DateTime.now().toIso8601String()}';
      final bytes = utf8.encode(rawString);
      final hash = sha256.convert(bytes).toString();

      final invitation = AccessInvitationModel(
        id: docRef.id,
        hostId: hostId,
        guestName: guestName,
        accessType: accessType,
        qrCodeHash: hash,
        validFrom: validFrom,
        validUntil: validUntil,
        status: 'active',
      );

      await docRef.set(invitation.toJson());
      return invitation;
    } catch (e) {
      print('Error creando invitación: $e');
      return null;
    }
  }

  /// Validar acceso mediante Hash (Escaneo de QR)
  Future<Map<String, dynamic>> validateAccess(String qrHash) async {
    try {
      // 1. Buscar la invitación por hash
      final querySnapshot = await _firestore
          .collection('access_invitations')
          .where('qr_code_hash', isEqualTo: qrHash)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return {'valid': false, 'reason': 'Código no encontrado'};
      }

      final doc = querySnapshot.docs.first;
      final invitation = AccessInvitationModel.fromJson(doc.data());

      // 2. Validar estatus
      if (invitation.status != 'active') {
        return {
          'valid': false, 
          'reason': 'Invitación ${invitation.status == 'used' ? 'ya utilizada' : 'cancelada/expirada'}'
        };
      }

      // 3. Validar fechas
      if (!invitation.isValid) {
        return {'valid': false, 'reason': 'Código fuera de horario o expirado'};
      }

      // 4. Obtener datos del anfitrión (Residente)
      final hostDoc = await _firestore.collection('users').doc(invitation.hostId).get();
      final hostName = hostDoc.exists 
          ? (hostDoc.data()?['full_name'] ?? 'Desconocido') 
          : 'Desconocido';
      
      // 5. Registrar acceso (Actualizar invitación)
      await doc.reference.update({
        'status': 'used',
        'entry_time': FieldValue.serverTimestamp(),
      });

      return {
        'valid': true,
        'guestName': invitation.guestName,
        'type': invitation.accessTypeName,
        'hostName': hostName,
        'address': 'Cluster 1, Casa 24', // En prod, buscar esto en PropertyModel
      };

    } catch (e) {
      print('Error validando acceso: $e');
      return {'valid': false, 'reason': 'Error del sistema'};
    }
  }

  /// Simular apertura remota de portón
  Future<bool> triggerGateOpen() async {
    try {
      // Simular delay de red/IoT
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- Lógica de Recorridos (Patrols) ---
  
  String? _currentPatrolId;
  String? get currentPatrolId => _currentPatrolId;

  /// Iniciar un recorrido
  Future<String?> startPatrol(String guardId) async {
    try {
      final docRef = _firestore.collection('guard_patrols').doc();
      
      await docRef.set({
        'id': docRef.id,
        'guard_id': guardId,
        'start_time': FieldValue.serverTimestamp(),
        'status': 'active',
        'path': [], // Array de {lat, lng, timestamp}
      });

      _currentPatrolId = docRef.id;
      notifyListeners();
      return _currentPatrolId;
    } catch (e) {
      print('Error iniciando recorrido: $e');
      return null;
    }
  }

  /// Finalizar recorrido
  Future<void> stopPatrol() async {
    if (_currentPatrolId == null) return;

    try {
      await _firestore.collection('guard_patrols').doc(_currentPatrolId).update({
        'status': 'completed',
        'end_time': FieldValue.serverTimestamp(),
      });

      _currentPatrolId = null;
      notifyListeners();
    } catch (e) {
      print('Error finalizando recorrido: $e');
    }
  }

  /// Actualizar ubicación del recorrido
  Future<void> updatePatrolLocation(double lat, double lng) async {
    if (_currentPatrolId == null) return;

    try {
      final point = {
        'lat': lat,
        'lng': lng,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('guard_patrols').doc(_currentPatrolId).update({
        'path': FieldValue.arrayUnion([point]),
      });
    } catch (e) {
      print('Error actualizando ubicación: $e');
    }
  }
}

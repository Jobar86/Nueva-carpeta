import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../config/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/security_service.dart';
import '../../services/panic_service.dart';

class PatrolMapScreen extends StatefulWidget {
  const PatrolMapScreen({super.key});

  @override
  State<PatrolMapScreen> createState() => _PatrolMapScreenState();
}

class _PatrolMapScreenState extends State<PatrolMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // Ubicación inicial (Demo: Centro de ciudad o ubicación simulada)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.4326, -99.1332), // CDMX por defecto
    zoom: 16,
  );

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _pathPoints = [];
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ));
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  void _togglePatrol() async {
    final securityService = Provider.of<SecurityService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (_isTracking) {
      // Detener recorrido
      await securityService.stopPatrol();
      _positionStream?.cancel();
      setState(() => _isTracking = false);
    } else {
      // Iniciar recorrido
      final patrolId = await securityService.startPatrol(authService.userId!);
      if (patrolId != null) {
        setState(() {
          _isTracking = true;
          _pathPoints = [];
          _polylines = {};
        });
        _startTracking();
      }
    }
  }

  void _startTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _pathPoints.add(latLng);
        _polylines = {
          Polyline(
            polylineId: const PolylineId('patrol_path'),
            color: Colors.blue,
            width: 5,
            points: _pathPoints,
          ),
        };
      });

      // Actualizar en backend
      Provider.of<SecurityService>(context, listen: false)
          .updatePatrolLocation(position.latitude, position.longitude);
      
      // Mover cámara
      _controller.future.then((controller) {
        controller.animateCamera(CameraUpdate.newLatLng(latLng));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final securityService = Provider.of<SecurityService>(context);
    final String? activePatrolId = securityService.currentPatrolId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorrido de Vigilancia'),
        actions: [
          if (activePatrolId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                   Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                   SizedBox(width: 6),
                   Text('EN VIVO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: _polylines,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          
          // Debug Overlay for Web (if map doesn't load)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: const Text(
                'Nota: En Web el mapa requiere API Key válida.\nSi ves esto gris, usa la ubicación simulada.',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _togglePatrol,
        backgroundColor: _isTracking ? Colors.red : Colors.green,
        icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
        label: Text(_isTracking ? 'Finalizar Recorrido' : 'Iniciar Recorrido'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

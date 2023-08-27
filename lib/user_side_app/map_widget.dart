import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  StreamSubscription<DocumentSnapshot>? _locationStream;
  Location _location = Location();
  String? _deviceId;
  int _deviceNumber = 0; // The number of devices where the app is installed
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInsideGeofence = false;
  bool _notificationShown =
      false; // Flag to track if the notification has been shown
  DateTime? _lastNotificationTime; // Timestamp of the last notification shown

  @override
  void initState() {
    super.initState();
    _getDeviceNumber();
    _getDeviceId();
    _startLocationUpdates();
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      _sendLocationToFirestore();
    });
    _setInitialCameraPosition();
    _fetchDataAndAddGeofence();

    // Initialize notification plugin for Android
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _locationStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
        circles: _circles,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _locateToMarkerPosition,
            tooltip: 'Locate to Marker',
            child: Icon(Icons.location_on),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _refreshMap,
            tooltip: 'Refresh',
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void _getDeviceNumber() {
    _deviceNumber = 1;
  }

  void _getDeviceId() {
    var uuid = Uuid();
    _deviceId =
        'police_man${_deviceNumber > 1 ? _deviceNumber.toString() : ''}_${uuid.v4()}';
  }

  void _setInitialCameraPosition() async {
    try {
      LocationData currentLocation = await _location.getLocation();
      LatLng initialPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _updateMarker(initialPosition);
      _mapController?.animateCamera(CameraUpdate.newLatLng(initialPosition));
    } catch (e) {
      print('Error setting initial camera position: $e');
    }
  }

  void _startLocationUpdates() {
    String collectionName = 'location';
    String documentId = _deviceId!;

    _locationStream = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        double latitude = data['latitude'];
        double longitude = data['longitude'];

        _updateMarker(LatLng(latitude, longitude));

        // Check geofence and show notification
        _checkGeofenceAndShowNotification(LatLng(latitude, longitude));
      } else {
        print('Document does not exist in Firestore.');
      }
    });
  }

  void _locateToMarkerPosition() {
    if (_markers.isNotEmpty) {
      LatLng markerPosition = _markers.first.position;
      _mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(markerPosition, 18));
    }
  }

  void _sendLocationToFirestore() async {
    try {
      LocationData currentLocation = await _location.getLocation();
      double latitude = currentLocation.latitude!;
      double longitude = currentLocation.longitude!;
      String time = DateTime.now().toIso8601String();

      String collectionName = 'location';
      String documentId = _deviceId!;

      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .set({
        'latitude': latitude,
        'longitude': longitude,
        'deviceId': _deviceId,
        'time': time,
      });

      print('Location sent to Firestore: $latitude, $longitude');
    } catch (e) {
      print('Error sending location to Firestore: $e');
    }
  }

  void _updateMarker(LatLng target) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("user_marker"),
          position: target,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'User',
            snippet: 'Device ID: $_deviceId',
          ),
        ),
      );
    });
  }

  Future<void> _fetchDataAndAddGeofence() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Schedule').get();

    querySnapshot.docs.forEach((doc) {
      double latitude = doc['latitude'] as double;
      double longitude = doc['longitude'] as double;

      _circles.add(Circle(
        circleId: CircleId(doc.id),
        center: LatLng(latitude, longitude),
        radius: 100,
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ));
    });

    setState(() {});
  }

  void _refreshMap() {
    _setInitialCameraPosition();
    _fetchDataAndAddGeofence();
  }

  void _checkGeofenceAndShowNotification(LatLng liveLocation) {
    bool isInsideGeofence = false;
    _circles.forEach((circle) {
      double distanceInMeters =
          _calculateDistanceInMeters(circle.center, liveLocation);
      if (distanceInMeters <= circle.radius) {
        isInsideGeofence = true;
      }
    });

    if (isInsideGeofence) {
      _notificationShown =
          false; // Reset notification flag to allow showing again
    } else {
      // If user exited the geofenced area
      if (_isInsideGeofence) {
        _uploadNotificationToFirestore('exit');
        _showNotificationPopup('Exited the deployment area');
      }
      _isInsideGeofence = false;
    }

    // Check if the notification hasn't been shown recently
    if (!_notificationShown) {
      if (_lastNotificationTime == null ||
          DateTime.now().difference(_lastNotificationTime!) >
              Duration(minutes: 5)) {
        if (!isInsideGeofence) {
          _uploadNotificationToFirestore('entry');
          _showNotificationPopup('Exited the deployment area');
        }
        _showGeofenceNotification();
        _notificationShown = true;
        _lastNotificationTime = DateTime.now();
      }
    } else {
      // If user re-entered the geofenced area after exiting
      if (isInsideGeofence && !_isInsideGeofence) {
        _uploadNotificationToFirestore('reentry');
        _showNotificationPopup('Exited the deployment area');
      }
    }
    _isInsideGeofence = isInsideGeofence;
  }

  Future<void> _uploadNotificationToFirestore(String status) async {
    try {
      String collectionName = 'notifications';
      String documentId = Uuid().v4();

      double latitude = _markers.first.position.latitude;
      double longitude = _markers.first.position.longitude;
      String time = DateTime.now().toIso8601String();

      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .set({
        'latitude': latitude,
        'longitude': longitude,
        'deviceId': _deviceId,
        'status': status,
        'time': time,
      });

      print(
          'Notification data sent to Firestore: $status, $latitude, $longitude');
    } catch (e) {
      print('Error uploading notification data to Firestore: $e');
    }
  }

  double _calculateDistanceInMeters(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // in meters
    double lat1 = point1.latitude * (pi / 180);
    double lon1 = point1.longitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);
    double lon2 = point2.longitude * (pi / 180);
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  void _showNotificationPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

void _showGeofenceNotification() {}

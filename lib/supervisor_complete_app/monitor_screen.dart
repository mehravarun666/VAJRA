import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MonitorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Screen'),
      ),
      body: GoogleMapWidget(), // You can use the Google Map widget here
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final LatLng _initialCameraPosition = LatLng(24.59047047491956,
      73.70555451889626); // Initial camera position (New York)
  Set<Circle> _circles = Set();
  Set<Marker> _markers = Set();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore and add geofence and markers
    _fetchDataAndAddGeofence();
    _fetchAndAddMarkers();

    // Start a 10-second timer to continuously fetch data
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      _fetchAndAddMarkers();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDataAndAddGeofence() async {
    // Fetch data from Firestore "Schedule" collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Schedule').get();

    // Process each document in the query result
    querySnapshot.docs.forEach((doc) {
      double latitude = doc['latitude'] as double;
      double longitude = doc['longitude'] as double;

      // Add a geofence circle with 1 km radius for each location
      _circles.add(Circle(
        circleId: CircleId(doc.id),
        center: LatLng(latitude, longitude),
        radius: 100, // 1 kilometer in meters
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ));
    });

    setState(() {});
  }

  Future<void> _fetchAndAddMarkers() async {
    // Fetch data from Firestore "location" collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('location').get();

    // Process each document in the query result
    _markers.clear();
    querySnapshot.docs.forEach((doc) {
      double latitude = doc['latitude'] as double;
      double longitude = doc['longitude'] as double;

      // Add a marker for each location
      _markers.add(Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: 'Location Marker'),
      ));
    });

    // Check if any marker is outside the geofenced area
    _checkMarkersInGeofence();

    setState(() {});
  }

  void _checkMarkersInGeofence() {
    bool isAnyMarkerInsideGeofence = false;

    _markers.forEach((marker) {
      bool isInsideGeofence = _isMarkerInsideGeofence(marker.position);
      if (isInsideGeofence) {
        isAnyMarkerInsideGeofence = true;
      }
    });

    // Check if any marker is outside all geofenced circles
    if (!isAnyMarkerInsideGeofence) {
      _showAlert();
    }
  }

  bool _isMarkerInsideGeofence(LatLng markerPosition) {
    // Check if the marker is inside any of the geofenced circles
    for (Circle circle in _circles) {
      double distance = calculateDistance(
        circle.center.latitude,
        circle.center.longitude,
        markerPosition.latitude,
        markerPosition.longitude,
      );
      if (distance <= circle.radius) {
        return true;
      }
    }
    return false;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371.0; // Earth radius in kilometers
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('Marker is outside the geofenced area.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    // .then((value) {
    //   // Call _hideAlert after the AlertDialog is dismissed
    //   _hideAlert();
    // });
  }

  // void _hideAlert() {
  //   // Delay the Navigator.pop call to give the user some time to read the alert
  //   Future.delayed(Duration(seconds: 3), () {
  //     Navigator.pop(context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialCameraPosition,
        zoom: 10,
      ),
      circles: _circles,
      markers: _markers,
      onMapCreated: (controller) {
        setState(() {});
      },
    );
  }
}

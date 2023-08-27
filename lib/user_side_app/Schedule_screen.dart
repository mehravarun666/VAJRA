import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Schedule').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('No data available.'),
            );
          }

          // Process the data and create a list of events
          List<Event> events = [];
          for (var doc in snapshot.data!.docs) {
            var scheduleData = doc.data() as Map<String, dynamic>;
            String title = scheduleData['title'] ?? 'Untitled';
            String time = scheduleData['time'] ?? '';
            double latitude = scheduleData['latitude'] ?? 0.0;
            double longitude = scheduleData['longitude'] ?? 0.0;
            String policemen = scheduleData['policemen'] ?? '';

            Event event = Event(
              title: title,
              time: time,
              latitude: latitude,
              longitude: longitude,
              policemen: policemen,
            );
            events.add(event);
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index];
              return ListTile(
                title: Text(
                  event.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time: ${event.time}'),
                    Text('Latitude: ${event.latitude}'),
                    Text('Longitude: ${event.longitude}'),
                    Text('Policeman: ${event.policemen}'),
                    SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Event {
  final String title;
  final String time;
  final double latitude;
  final double longitude;
  final String policemen;

  Event({
    required this.title,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.policemen,
  });
}

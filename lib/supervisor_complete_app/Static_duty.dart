import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_service.dart';
import 'monitor_screen.dart';

class Static_duty extends StatefulWidget {
  @override
  _Static_dutyState createState() => _Static_dutyState();
}

class _Static_dutyState extends State<Static_duty> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final FirebaseService _firebaseService = FirebaseService();
  List<String> policemen = [];
  Set<String> selectedPolicemen = {};
  String selectedDate = 'Select Date';
  String selectedTime = 'Select Time';

  List<Location> locations = [
    Location(
        name: 'Surajpole',
        latitude: 24.58069602908181,
        longitude: 73.69537719142393), //24.58069602908181, 73.69537719142393
    Location(
        name: 'Delhi Gate',
        latitude: 24.585737201390824,
        longitude: 73.69539699778322), //24.585737201390824, 73.69539699778322
    Location(
        name: 'Greater Noida',
        latitude: 24.620834879475797, //24.620834879475797, 73.85465786710277
        longitude: 73.85465786710277), //28.57667918001886, 77.43976255220421
    Location(
        name: 'Chetak Circle',
        latitude: 24.59101340513082,
        longitude: 73.69018668272746), //24.59101340513082, 73.69018668272746
    Location(
        name: 'Shobhagpura',
        latitude: 24.60781956695415,
        longitude: 73.70892903826706), //24.60781956695415, 73.70892903826706
    Location(
        name: 'Dabok',
        latitude: 24.6131882954459,
        longitude: 73.8624004694102), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Geetanjali',
        latitude: 24.620688575055883,
        longitude: 73.85466863710725), //24.620688575055883, 73.85466863710725
    Location(
        name: 'sharda university',
        latitude: 28.47276922909774,
        longitude: 77.48229595971662), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Radison Blu',
        latitude: 28.452392729160483,
        longitude: 77.53072882255103), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Grand Venice mall',
        latitude: 28.48541963233377,
        longitude: 77.52641293341611), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Wipro office',
        latitude: 24.620688575055883,
        longitude: 77.53326812478005), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Galgotia Uni',
        latitude: 28.37131390787205,
        longitude: 77.54066372498758), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Microsoft office',
        latitude: 28.568299547167257,
        longitude: 77.316227111646), //24.620688575055883, 73.85466863710725
    Location(
        name: 'GL BAJAJ',
        latitude: 28.47285078488518,
        longitude: 77.48852158046098), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Pari Chowk',
        latitude: 28.465957887513074,
        longitude: 77.51116473207028), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Knowledge Park 2',
        latitude: 28.456870321231698,
        longitude: 77.50020648620598), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Pari Chowk',
        latitude: 28.47285078488518,
        longitude: 77.48852158046098), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Aims Hospital',
        latitude: 28.47006178718634,
        longitude: 77.50937471019957), //24.620688575055883, 73.85466863710725
    Location(
        name: 'Rashtrapati Bhavan',
        latitude: 28.614380790957302,
        longitude: 77.19942605548772), //24.620688575055883, 73.85466863710725
    Location(
        name: 'HANUMAN MANDIR KAROL BAGH',
        latitude: 28.645097501048582,
        longitude: 77.19811818897846), //24.620688575055883, 73.85466863710725
  ];

  Location? selectedLocation;

  @override
  void initState() {
    super.initState();
    _fetchPolicemenNames();
  }

  Future<void> _fetchPolicemenNames() async {
    List<String> names = await _firebaseService.getPolicemenNames();
    setState(() {
      policemen = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: selectedPolicemen.isEmpty
                  ? 'Select Policeman'
                  : selectedPolicemen.join(', '),
              onPressed: () => _showPolicemenMenu(context),
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              shadowColor: Colors.blue.withOpacity(0.7),
            ),
            CustomButton(
              text: selectedDate,
              onPressed: () => _selectDate(context),
              backgroundColor: Colors.green,
              textColor: Colors.white,
              shadowColor: Colors.green.withOpacity(0.7),
            ),

            // CustomButton(
            //   text: startTime == null
            //       ? 'Select Start Time'
            //       : 'Start Time: ${startTime!.format(context)}',
            //   onPressed: () => _selectTime(context, true),
            //   backgroundColor: Colors.orange,
            //   textColor: Colors.white,
            //   shadowColor: Colors.orange.withOpacity(0.7),
            // ),
            // CustomButton(
            //   text: endTime == null
            //       ? 'Select End Time'
            //       : 'End Time: ${endTime!.format(context)}',
            //   onPressed: () => _selectTime(context, false),
            //   backgroundColor: Colors.orange,
            //   textColor: Colors.white,
            //   shadowColor: Colors.orange.withOpacity(0.7),
            // ),

            CustomButton(
              text: selectedTime,
              onPressed: () => _selectTime(context),
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              shadowColor: Colors.orange.withOpacity(0.7),
            ),
            CustomButton(
              text: selectedLocation == null
                  ? "Location"
                  : selectedLocation!.name,
              onPressed: () => _showLocationMenu(context),
              backgroundColor: Colors.purple,
              textColor: Colors.white,
              shadowColor: Colors.purple.withOpacity(0.7),
            ),
            CustomButton(
              text: 'Submit',
              onPressed: _submitForm,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              shadowColor: Colors.red.withOpacity(0.7),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MonitorScreen()),
          );
        },
        child: Icon(Icons.monitor),
      ),
    );
  }

  // Future<void> _selectTime(BuildContext context, bool isStartTime) async {
  //   TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (pickedTime != null) {
  //     setState(() {
  //       if (isStartTime) {
  //         startTime = pickedTime;
  //       } else {
  //         endTime = pickedTime;
  //       }
  //     });
  //     // Add any additional logic based on the selected time if needed
  //   }
  // }

  void _showPolicemenMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: policemen.length,
            itemBuilder: (BuildContext context, int index) {
              final String name = policemen[index];
              return PolicemanTile(
                name: name,
                isSelected: selectedPolicemen.contains(name),
                onTap: () {
                  setState(() {
                    if (selectedPolicemen.contains(name)) {
                      selectedPolicemen.remove(name);
                    } else {
                      selectedPolicemen.add(name);
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showLocationMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: locations.length,
            itemBuilder: (BuildContext context, int index) {
              final location = locations[index];
              return LocationTile(
                location: location,
                isSelected: selectedLocation == location,
                onTap: () {
                  setState(() {
                    if (selectedLocation == location) {
                      selectedLocation = null;
                    } else {
                      selectedLocation = location;
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
      // Add any additional logic based on the selected date if needed
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = "${pickedTime.format(context)}";
      });
      // Add any additional logic based on the selected time if needed
    }
  }

  void _submitForm() async {
    // Get the selected data from the buttons
    String selectedPolicemenData = selectedPolicemen.join(', ');
    String selectedDateData = selectedDate;
    TimeOfDay? selectedstartTimeData = startTime;
    TimeOfDay? selectedendTimeData = endTime;
    double latitude = selectedLocation?.latitude ?? 0.0;
    double longitude = selectedLocation?.longitude ?? 0.0;

    // Create a document to be sent to Firestore
    Map<String, dynamic> scheduleData = {
      'policemen': selectedPolicemenData,
      'date': selectedDateData,
      'starttime': selectedstartTimeData,
      'endtime': selectedendTimeData,
      'latitude': latitude,
      'longitude': longitude,
    };

    // Send the data to Firestore under the "Schedule" collection
    try {
      await FirebaseFirestore.instance.collection('Schedule').add(scheduleData);
      // If successful, show a success message or perform other actions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Data submitted successfully to Firestore.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // If there's an error, show an error message or perform other actions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to submit data to Firestore.'),
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
}

class PolicemanTile extends StatefulWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  PolicemanTile({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _PolicemanTileState createState() => _PolicemanTileState();
}

class _PolicemanTileState extends State<PolicemanTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      onTap: widget.onTap,
      trailing: widget.isSelected
          ? Icon(Icons.check_circle, color: Colors.green)
          : null,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;

  CustomButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 200,
        height: 80,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: backgroundColor,
            onPrimary: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            shadowColor: shadowColor,
            elevation: 5,
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}

class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LocationTile extends StatelessWidget {
  final Location location;
  final bool isSelected;
  final VoidCallback onTap;

  LocationTile(
      {required this.location, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(location.name),
      subtitle: Text(
          'Latitude: ${location.latitude}, Longitude: ${location.longitude}'),
      onTap: onTap,
      trailing:
          isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
    );
  }
}
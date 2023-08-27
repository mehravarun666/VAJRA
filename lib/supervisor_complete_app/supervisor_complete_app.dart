import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'CapturedImagesFromPoleScreen.dart';
import 'assigning_duty.dart';
import 'CapturedImagesScreen.dart';
import 'ReportsScreen.dart';
import 'DepartmentsScreen.dart';
import 'monitor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen',
      home: SupervisorCompleteApp(),
    );
  }
}

class SupervisorCompleteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Button Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            MyHeaderDrawer(),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more drawer items as needed
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/background_image.jpg'),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Padding(
          padding: EdgeInsets.all(
              8.0), // Add 2mm spacing (approximately) from each side
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonitorScreen()),
                    );
                    // Large button logic
                    // print('Large Button Pressed!');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors
                        .transparent, // Transparent background for the button
                    padding: EdgeInsets.all(
                        24.0), // Increase padding for larger size
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Apply rounded corners
                      side: BorderSide(
                          width: 3.0,
                          color: Colors
                              .white), // Add a 3mm boundary around the button
                    ),
                    elevation: 5.0, // Add shadow to the button
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/large_button_image.jpg', // Replace with your image path
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom:
                            10, // Move the text 1cm (10 units) downward from the bottom
                        child: Text(
                          'Monitor Screen',
                          style: TextStyle(
                            fontSize: 20.0, // Increase font size
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height:
                      16.0), // Add some vertical spacing between large button and grid
              Expanded(
                flex: 2,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    CircularGradientButton(
                      label: 'Assign Duties',
                      onPressed: () {
                        // Square button 1 logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Assigning_duty()),
                        );
                      },
                      gradientColors: [
                        Colors.orangeAccent,
                        Colors.deepOrange
                      ], // Gradient colors for square button 1
                    ),
                    CircularGradientButton(
                      label: 'Random check-ins images',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CapturedImagesFromPoleScreen()),
                        );
                      },
                      gradientColors: [
                        Colors.pinkAccent,
                        Colors.purple
                      ], // Gradient colors for square button 2
                    ),
                    CircularGradientButton(
                      label: 'Camera Images',
                      onPressed: () {
                        // Square button 3 logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CapturedImagesScreen()),
                        );
                      },
                      gradientColors: [
                        Colors.greenAccent,
                        Colors.lightGreen
                      ], // Gradient colors for square button 3
                    ),
                    CircularGradientButton(
                      label: 'Other departments',
                      onPressed: () {
                        // Square button 4 logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DepartmentsScreen()), // Add the DepartmentsScreen here
                        );
                      },
                      gradientColors: [
                        Colors.blueAccent,
                        Colors.indigo
                      ], // Gradient colors for square button 4
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              // Add the "See Reports" button here
              ElevatedButton(
                onPressed: () {
                  // Logic for "See Reports" button
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReportsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Customize the button color
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'See Reports',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHeaderDrawer extends StatelessWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/pols.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            "Inspector Suresh Kumar",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "sureshkumar@gmail.com",
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CircularGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final List<Color> gradientColors;

  const CircularGradientButton(
      {required this.label,
      required this.onPressed,
      required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Make the button circular
        ),
        elevation: 3.0, // Add shadow to the button
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          constraints: BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to the Dashboard'),
      ),
    );
  }
}

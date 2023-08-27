import 'package:flutter/material.dart';

class DepartmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vertical Buttons App'),
        ),
        body: Container(
          padding: EdgeInsets.all(16), // 1 cm padding from all sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RoundedButton(
                  text: 'AMBULANCE',
                  backgroundImage:
                      'assets/ambulance.png', // Replace with your image asset path
                  onPressed: () {
                    // Add your action for button 1 here
                  },
                ),
              ),
              SizedBox(height: 16), // Add some spacing between buttons
              Expanded(
                child: RoundedButton(
                  text: 'FIRE BRIGADE',
                  backgroundImage:
                      'assets/fire_brigade.png', // Replace with your image asset path
                  onPressed: () {
                    // Add your action for button 2 here
                  },
                ),
              ),
              SizedBox(height: 16), // Add some spacing between buttons
              Expanded(
                child: RoundedButton(
                  text: 'SPECIAL FORCES',
                  backgroundImage:
                      'assets/special_forces.png', // Replace with your image asset path
                  onPressed: () {
                    // Add your action for button 3 here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final String backgroundImage;
  final VoidCallback onPressed;

  const RoundedButton({
    required this.text,
    required this.backgroundImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = (screenHeight - 64) / 3 -
        32; // 1 cm margin from top and bottom of the screen

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF333333), // Black
                  Color(0xFF808080), // Grey
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: buttonHeight,
              alignment: Alignment.center,
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16), // 1 cm above the text
                  Text(
                    text,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

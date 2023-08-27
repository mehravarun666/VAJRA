import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phoneauth_firebase/user_side_app/userapp.dart';

// ScannedScreen.dart

// nfcscreen.dart
class nfcscreen extends StatefulWidget {
  const nfcscreen({Key? key}) : super(key: key);

  @override
  State<nfcscreen> createState() => _nfcscreenState();
}

class _nfcscreenState extends State<nfcscreen> {
  void navigateToPhotoScreen() {
    Future.delayed(Duration(seconds: 7), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    navigateToPhotoScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Lottie.asset(
                'assets/a4.json',
                height: 600.00,
                width: 600.00,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            const Text(
              "Scanning NFC....",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 250,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: nfcscreen(),
  ));
}

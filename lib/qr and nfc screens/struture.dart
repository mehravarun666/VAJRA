import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'nfc.dart';
import 'qr.dart';

class MyHomepage extends StatelessWidget {
  const MyHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Lottie.asset('assets/a3.json',
                  height: 360.0,
                  width: 360.0,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => nfcscreen()));
              },
              child: Text(
                "NFC scan",
              ),
              style:
                  ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 30)),
            ),
            SizedBox(
              height: 10,
            ),
            Lottie.asset(
              'assets/a2.json',
              fit: BoxFit.fitWidth,
              height: 360.0,
              width: 360.0,
              alignment: Alignment.bottomCenter,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QRScannerPage()));
              },
              child: Text(
                "QR scan",
              ),
              style:
                  ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 30)),
            )
          ],
        ),
      ),
    );
  }
}

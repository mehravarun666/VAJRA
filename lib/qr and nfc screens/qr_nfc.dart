import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QrNfc extends StatefulWidget {
  const QrNfc({Key? key}) : super(key: key);

  @override
  _QrNfcState createState() => _QrNfcState();
}

class _QrNfcState extends State<QrNfc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Lottie.asset('qr_nfc_app/assets/a2.json'),
    ));
  }
}

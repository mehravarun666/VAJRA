import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phoneauth_firebase/supevisor_login/reusable_widgets/reusable_widget.dart';
import 'package:phoneauth_firebase/supevisor_login/utils/color_utils.dart';

// Import your SupervisorCompleteApp widget from the supervisor_complete_app.dart file
import 'package:phoneauth_firebase/supervisor_complete_app/supervisor_complete_app.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  void _uploadDataToFirestore() {
    // Get the current date and time
    DateTime currentDate = DateTime.now();

    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Prepare the data to be uploaded
    Map<String, dynamic> userData = {
      "username": _userNameTextController.text,
      "email": _emailTextController.text,
      "date": currentDate,
    };

    // Upload the data to Firestore
    firestore.collection("supervisor").add(userData).then((docRef) {
      print("Document uploaded with ID: ${docRef.id}");

      // Navigate to the SupervisorCompleteApp widget
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupervisorCompleteApp()),
      );
    }).catchError((error) {
      print("Error uploading data: ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", _uploadDataToFirestore),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpScreen(),
  ));
}

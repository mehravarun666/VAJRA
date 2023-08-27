import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SosSendingScreen extends StatefulWidget {
  @override
  _SosSendingScreenState createState() => _SosSendingScreenState();
}

class _SosSendingScreenState extends State<SosSendingScreen> {
  File? _pickedFile; // Store the File object directly
  final TextEditingController _messageController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path); // Store the File object
      });
    }
  }

  Future<void> _sendSos() async {
    if (_pickedFile == null) {
      return; // Image not captured
    }

    try {
      File imageFile = _pickedFile!; // Use the stored File object

      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('report_images/$imageName.jpg');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});

      String imageUrl = await storageSnapshot.ref.getDownloadURL();

      // Generate a new unique ID for the document in Firestore
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('SOS').doc();

      // Store the message and image URL in Firestore
      await docRef.set({
        'image_url': imageUrl,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      setState(() {
        _pickedFile = null;
      });
    } catch (e) {
      print('Error: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _pickedFile != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        _pickedFile!, // Use the stored File object
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Capture Image'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendSos,
              child: Text('Send SOS'),
            ),
          ],
        ),
      ),
    );
  }
}

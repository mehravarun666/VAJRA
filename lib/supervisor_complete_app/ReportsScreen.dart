import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<String> _photoUrls = [];
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchPhotosAndMessages();
  }

  Future<void> _fetchPhotosAndMessages() async {
    try {
      await _fetchPhotos();
      await _fetchMessages();
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  Future<void> _fetchPhotos() async {
    try {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference folderRef = storage.ref('report_images');
      firebase_storage.ListResult result = await folderRef.listAll();

      List<String> photoUrls = [];
      for (var item in result.items) {
        String downloadURL = await item.getDownloadURL();
        photoUrls.add(downloadURL);
      }

      setState(() {
        _photoUrls = photoUrls;
      });
    } catch (e) {
      print('Error fetching photos: $e');
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  Future<void> _fetchMessages() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('SOS').get();

      List<String> messages = [];
      querySnapshot.docs.forEach((doc) {
        // Assuming you have a field called 'message' in the SOS documents
        String? message =
            (doc.data() as Map<String, dynamic>)['message'] as String?;
        if (message != null) {
          messages.add(message);
        }
      });

      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _photoUrls.isEmpty
                ? Center(
                    child: Text(
                      'No images available.',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _photoUrls.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _photoUrls[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages available.',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_messages[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

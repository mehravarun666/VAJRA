import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CapturedImagesScreen extends StatefulWidget {
  @override
  _CapturedImagesScreenState createState() => _CapturedImagesScreenState();
}

class _CapturedImagesScreenState extends State<CapturedImagesScreen> {
  List<String> _photoUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    try {
      List<String> photoUrls = await fetchPhotoUrls();
      setState(() {
        _photoUrls = photoUrls;
      });
    } catch (e) {
      print('Error fetching photos: $e');
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  Future<List<String>> fetchPhotoUrls() async {
    try {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference folderRef = storage.ref('selfie');
      firebase_storage.ListResult result = await folderRef.listAll();

      List<String> photoUrls = [];
      for (var item in result.items) {
        String downloadURL = await item.getDownloadURL();
        photoUrls.add(downloadURL);
      }

      return photoUrls;
    } catch (e) {
      print('Error fetching photo URLs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Images'),
      ),
      body: _photoUrls.isEmpty
          ? Center(
              child: Text(
                'No images captured yet.',
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
    );
  }
}

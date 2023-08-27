import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Captured Images App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CapturedImagesFromPoleScreen(),
    );
  }
}

class CapturedImagesFromPoleScreen extends StatefulWidget {
  @override
  _CapturedImagesFromPoleScreenState createState() =>
      _CapturedImagesFromPoleScreenState();
}

class _CapturedImagesFromPoleScreenState
    extends State<CapturedImagesFromPoleScreen> {
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
    }
  }

  Future<List<String>> fetchPhotoUrls() async {
    try {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference folderRef = storage.ref('PLN');
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailScreen(
                          imageUrl: _photoUrls[index],
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    _photoUrls[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final String imageUrl;

  PhotoDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Detail'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

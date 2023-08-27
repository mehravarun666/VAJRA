import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<List<String>> getPolicemenNames() async {
    try {
      final querySnapshot = await _usersCollection.get();
      final names =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      return names;
    } catch (e) {
      print('Error fetching policemen names: $e');
      return [];
    }
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
class UserModel {
  String name;
  String email;
  String bio;
  String profilePic;
  String createdAt;
  String PhoneNumber;
  String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.profilePic,
    required this.createdAt,
    required this.PhoneNumber,
    required this.uid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profile_pic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      PhoneNumber: map['PhoneNumber'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "bio": bio,
      "profile_pic": profilePic,
      "PhoneNumber": PhoneNumber,
      "createdAt": createdAt,
    };
  }
}

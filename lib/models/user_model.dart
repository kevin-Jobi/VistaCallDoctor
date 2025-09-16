import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory UserModel.fromFirebaseUser(User firebaseUser){
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }
}
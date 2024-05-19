import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? imageUrl;

  UserModel({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNum,
    this.imageUrl,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      firstName: doc['firstname'],
      lastName: doc['lastname'],
      email: doc['email'],
      phoneNum: doc['phoneNum'],
      imageUrl: doc['imageurl'],
    );
  }
}

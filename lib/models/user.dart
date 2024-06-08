import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? imageUrl;
  String? curAddress;
  GeoPoint? curLoc;

  UserModel({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNum,
    this.imageUrl,
    this.curAddress,
    this.curLoc,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      firstName: data['firstname'] as String?,
      lastName: data['lastname'] as String?,
      email: data['email'] as String?,
      phoneNum: data['phoneNum'] as String?,
      imageUrl: data['imageurl'] as String?,
      curAddress: data['current address'] as String?,
      curLoc: data['current location'] as GeoPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phoneNum': phoneNum,
      'imageurl': imageUrl,
      'current address': curAddress,
      'current location': curLoc,
    };
  }
}

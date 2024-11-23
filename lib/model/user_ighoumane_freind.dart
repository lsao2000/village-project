import 'package:cloud_firestore/cloud_firestore.dart';

class UserIghoumaneFreind {
  late String _id;
  late String _firstName;
  late String _lastName;
  UserIghoumaneFreind(
      {required String id, required String firstName, required String lastName})
      : _lastName = lastName,
        _firstName = firstName,
        _id = id;
  String get getFirstName => _firstName;
  String get getastName => _lastName;
  String get getId => _id;
  //Map<String, dynamic> toMap(){
  //    return {
  //        ""
  //    };
  //}
  UserIghoumaneFreind.getFromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> data) {
    _id = data.id;
    _firstName = data["firstName"];
    _lastName = data["lastName"];
  }
}

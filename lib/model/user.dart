import 'package:cloud_firestore/cloud_firestore.dart';

class IghoumaneUser {
  late final String _userId;
  late final String _firstName;
  late final String _lastName;
  late final String _phoneNumber;
  late final DateTime _createdAt;
  late final String _password;
  String _description = "";
  IghoumaneUser({
    //required String userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime createAt,
    required String password,
  })  : _firstName = firstName,
        _lastName = lastName,
        _phoneNumber = phoneNumber,
        _password = password,
        _createdAt = createAt;
  Map<String, dynamic> toMap() {
    return {
      "user_id": _userId,
      "firstName": _firstName,
      "lastName": _lastName,
      "phoneNumber": _phoneNumber,
      "password": _password,
      "createdAt": _createdAt,
      "description": _description
    };
  }
  IghoumaneUser.fromMap(Map<String, dynamic> data){
    _firstName = data["firstName"];
    _lastName = data["lastName"];
    _userId = data["user_id"];
    Timestamp date = data["createdAt"];
    _createdAt = date.toDate();
    _password = "";
    _phoneNumber = "";
  }

  IghoumaneUser.getUserFromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> user) {
    _firstName = user["firstName"];
    _lastName = user["lastName"];
    _userId = user["user_id"];
    Timestamp date = user["createdAt"];
    _createdAt = date.toDate();
    _password = "";
    _phoneNumber = "";
  }
  set setUserId(String userId) {
    _userId = userId;
  }

  String get getDescription => _description;
  set setDescription(String descrpiton) {
    _description = descrpiton;
  }

  String get getPassword => _password;
  String get getUserId => _userId;
  String get getFirstName => _firstName;
  String get getLastName => _lastName;
  String get getPhoneNumber => _phoneNumber;
  DateTime get getCreatedDate => _createdAt;
}

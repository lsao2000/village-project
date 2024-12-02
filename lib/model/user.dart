import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IghoumaneUser {
  late final String _userId;
  late final String _firstName;
  late final String _lastName;
  late final String _phoneNumber;
  late final DateTime _createdAt;
  late final String _password;
  String pushToken = "";
  String? chatingWith;
  late List<String> _lstFreindsIds;
  String _description = "";
  IghoumaneUser(
      {
      //required String userId,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required DateTime createAt,
      required String password,
      required List<String> lstFreindsIds})
      : _firstName = firstName,
        _lastName = lastName,
        _phoneNumber = phoneNumber,
        _password = password,
        _lstFreindsIds = lstFreindsIds,
        _createdAt = createAt;
  IghoumaneUser.basicInfo(this._firstName, this._lastName);
  Map<String, dynamic> toMap() {
    return {
      "chatingWith": chatingWith,
      "user_id": _userId,
      "firstName": _firstName,
      "lastName": _lastName,
      "phoneNumber": _phoneNumber,
      "password": _password,
      "createdAt": _createdAt,
      "description": _description,
      "pushToken": pushToken
    };
  }

  IghoumaneUser.fromMap(Map<String, dynamic> data) {
    _firstName = data["firstName"];
    _lastName = data["lastName"];
    _userId = data["user_id"];
    chatingWith = data["chatingWith"];
    Timestamp date = data["createdAt"];
    _createdAt = date.toDate();
    _password = "";
    _phoneNumber = "";
    pushToken = data["pushToken"];
    _lstFreindsIds =
        data["freinds"] is Iterable ? List<String>.from(data["freinds"]) : [];
  }

  IghoumaneUser.getUserFromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> user) {
    chatingWith = user["chatingWith"];
    _firstName = user["firstName"];
    _lastName = user["lastName"];
    _userId = user["user_id"];
    Timestamp date = user["createdAt"];
    _createdAt = date.toDate();
    pushToken = user["pushToken"];
    _password = "";
    _phoneNumber = "";
    _lstFreindsIds = user["freinds"] ?? [];
  }
  set setUserId(String userId) {
    _userId = userId;
  }

  set setDescription(String descrpiton) {
    _description = descrpiton;
  }

  set setLstFreindIds(List<String> freindIds) {
    _lstFreindsIds = freindIds;
  }

  List<String> get getLstFreindsIds => _lstFreindsIds;
  String get getPassword => _password;
  String get getDescription => _description;
  String get getUserId => _userId;
  String get getFirstName => _firstName;
  String get getLastName => _lastName;
  String get getPhoneNumber => _phoneNumber;
  DateTime get getCreatedDate => _createdAt;
}

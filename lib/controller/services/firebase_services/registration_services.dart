import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:village_project/model/joined_user.dart';
import 'package:village_project/model/user.dart';

class RegistrationServices {
  static Future<bool> addUserInFirestore(
      {required JoinedUser joinedUser}) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection("JoinedUsers");
      DocumentReference newJoinedUserRef = users.doc();
      String userId = newJoinedUserRef.id;
      joinedUser.setUserId = userId;
      await newJoinedUserRef.set(joinedUser.toMap());
      return true;
    } catch (e) {
      log("error ${e.toString()}");
      return false;
    }
  }

  static Future<void> addNewUser(
      IghoumaneUser ighoumaneUser, UserCredential userCredential) async {
    try {
      CollectionReference userTable =
          FirebaseFirestore.instance.collection("users");
      //log(ighoumaneUser.getFirstName);
      DocumentReference newUser = userTable.doc(userCredential.user!.uid);
      //String userId = newUser.id;
      //ighoumaneUser.setUserId = userId;
      await newUser.set(ighoumaneUser.toMap());
    } catch (e) {
      log("failed user addition ${e.toString()}");
    }
  }
}

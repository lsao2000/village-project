import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/model/user.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class UserServices {
  static updateUserInfo(
      {required BuildContext context,
      required IghoumaneUser ighoumaneUser}) async {
    try {
      String userid = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser
          .getUserId;
      await db.collection("users").doc(userid).update(ighoumaneUser.toMap());
    } catch (e) {
      print("error in updateUser function ${e.toString()}");
    }
  }
}

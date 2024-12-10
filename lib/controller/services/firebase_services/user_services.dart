import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/model/user.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class UserServices {
  static Future<void> updateUserInfo(
      {required BuildContext context,
      required IghoumaneUser ighoumaneUser}) async {
    try {
      String userid = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser
          .getUserId;
      await db.collection("users").doc(userid).update(ighoumaneUser.toMap());
    } catch (e) {
      log("error in updateUser function ${e.toString()}");
    }
  }

  static Future<void> updateChatingWithStatus(
      {required String currentUserId, required String? chatingWith}) async {
    try {
      await db
          .collection("users")
          .doc(currentUserId)
          .update({"chatingWith": chatingWith});
    } catch (e) {
      log("fail to update chatingWith ${e.toString()}");
    }
  }

  static Future<void> updateConnectionStatus(
      {required String userId, required String connectionStatus}) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .update({"status": connectionStatus});
    } catch (e) {
      log("failed to update connectionStatus ${e.toString()}");
    }
  }
}

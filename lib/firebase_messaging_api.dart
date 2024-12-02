import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';

class FirebaseMessagingApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<void> requestNotificationPermission() async {
    try {
      await firebaseMessaging.requestPermission();
      final String? firebaseToken = await firebaseMessaging.getToken();
      _storeTokenInFirestore(firebaseToken!);
    } catch (e) {
      log("failed to get Permission ${e.toString()}");
    }
  }

  Future<void> _storeTokenInFirestore(String token) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      await db.collection("users").doc(user.uid).update({"pushToken": token});
    } catch (e) {
      log("failed to store token ${e.toString()}");
    }
  }
}

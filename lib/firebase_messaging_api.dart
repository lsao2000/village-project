import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';

class FirebaseMessagingApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> requestNotificationPermission() async {
    try {
      await firebaseMessaging.requestPermission();
      await configLocalNotification();
      final String? firebaseToken = await firebaseMessaging.getToken();
      _storeTokenInFirestore(firebaseToken!);
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          log("message : ${message.data.toString()}");
          if (message.notification != null) {
            log("message also contained some notification ${message.notification}");
          }
          showNotification(message);
        },
      );
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

  void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(message.messageId!, 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    //await flutterLocalNotificationsPlugin.
    log(message.notification!.body.toString());
    String titleMsg = message.notification!.title.toString();
    String bodyMsg = message.notification!.body.toString();
    await flutterLocalNotificationsPlugin.show(
        DateTime.now().second, titleMsg, bodyMsg, notificationDetails,
        payload: json.encode(message.data));
  }

  Future<void> configLocalNotification() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var darwinInitilizeSetting = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: darwinInitilizeSetting);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

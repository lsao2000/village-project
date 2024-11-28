import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/freindship_model.dart';
import 'package:village_project/model/message_model.dart';
import 'package:village_project/model/user.dart';

class ChatServices {
  static Future<IghoumaneUser> getFreindInfo({required String userId}) async {
    var data = await db.collection("users").doc(userId).get();
    IghoumaneUser ighoumaneUser =
        IghoumaneUser.basicInfo(data["firstName"], data["lastName"]);
    return ighoumaneUser;
  }

  static Future<FreindshipModel?> getFreindShipType(
      {required String freindId, required BuildContext context}) async {
    String currentUserId =
        Provider.of<IghoumaneUserProvider>(context, listen: false)
            .ighoumaneUser
            .getUserId;
    List<String> listIdsSorted = [freindId, currentUserId]..sort();
    var data = await db
        .collection("freindship")
        .where("user1_id", isEqualTo: listIdsSorted[0])
        .where("user2_id", isEqualTo: listIdsSorted[1])
        .get();
    if (data.docs.isEmpty) {
      return null;
    }
    FreindshipModel? freindshipModel =
        FreindshipModel.fromQuerySnapshot(data.docs.first);
    return freindshipModel;
  }

  static checkIfChatExist(
      {required String freindId,
      required BuildContext context,
      required String msgContent}) async {
    String currentUserId =
        Provider.of<IghoumaneUserProvider>(context, listen: false)
            .ighoumaneUser
            .getUserId;
    List<String> sortedIdsList = [freindId, currentUserId]..sort();
    try {
      var data = await db
          .collection("chats")
          .where("user1_id", isEqualTo: sortedIdsList[0])
          .where("user2_id", isEqualTo: sortedIdsList[1])
          .get();

      if (data.docs.isEmpty) {
        log("in the empty section");
        createChatDoc(
            currentUserId: currentUserId,
            msgContent: msgContent,
            freindId: freindId);
      } else {
        log("in the add section");
        addMessageToChatDoc(
            currentUserId: currentUserId,
            docId: data.docs.first.id,
            msgContent: msgContent);
      }
    } catch (e) {
      log("error to check chat ${e.toString()}");
    }
  }

  static void addMessageToChatDoc(
      {required String currentUserId,
      required String docId,
      required String msgContent}) async {
    try {
      var msgCollection =
          db.collection("chats").doc(docId).collection("messages");
      MessageModel messageModel = MessageModel.toAddInFirestore(
          senderId: currentUserId,
          text: msgContent,
          sendingTime: DateTime.now());
      msgCollection.add(messageModel.toMap());
    } catch (e) {
      log("failed to add to message collection ${e.toString()}");
    }
  }

  static void createChatDoc(
      {required String currentUserId,
      required String msgContent,
      required String freindId}) async {
    try {
      List<String> sortedIdsList = [freindId, currentUserId]..sort();
      var chatDocRef =
          db.collection("chats").doc("${sortedIdsList[0]}${sortedIdsList[1]}");
      MessageModel messageModel = MessageModel.toAddInFirestore(
          senderId: currentUserId,
          text: msgContent,
          sendingTime: DateTime.now());
      chatDocRef
          .set({"user1_id": sortedIdsList[0], "user2_id": sortedIdsList[1]});
      chatDocRef.collection("messages").doc().set(messageModel.toMap());
      log("succes to add message doc");
    } catch (e) {
      log("failed to create Chat Doc");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesFreind(
      {required String currentUserId, required String freindId}) {
    List<String> sortedList = [freindId, currentUserId]..sort();
    String docId = "${sortedList[0]}${sortedList[1]}";
    return db
        .collection("chats")
        .doc(docId)
        .collection("messages")
        .orderBy("sendingTime")
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessagesFreind(
      {required String currentUserId, required String freindId}) {
    List<String> sortedList = [freindId, currentUserId]..sort();
    String docId = "${sortedList[0]}${sortedList[1]}";
    return db
        .collection("chats")
        .doc(docId)
        .collection("messages")
        .orderBy("sendingTime", descending: true)
        .limit(1)
        .snapshots();
  }
}

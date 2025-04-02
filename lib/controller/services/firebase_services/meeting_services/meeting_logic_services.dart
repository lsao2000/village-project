import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/meeting_model.dart';

class MeetingLogicServices {
  static Future<String?> createMeeting(
      {required String meetingtoken,
      required List<String> invitedUsers,
      required String currentUserId,
      required String roleType,
      required String meetingStatus,
      required String title,
      required List<String> joinedUsers}) async {
    try {
      DateTime creationDate = DateTime.now();
      var doc = db.collection("meetings").doc();
      var data = await doc.set({
        "createdAt": creationDate,
        "adminId": currentUserId,
        "invitedUsers": FieldValue.arrayUnion(invitedUsers),
        "roleType": roleType,
        "meetingToken": meetingtoken,
        "title": title,
        "status": meetingStatus,
        "joinedUsers": FieldValue.arrayUnion(joinedUsers)
      }).onError((el, e) {
        print("error: ${el.toString()}");
        //log("error: ${el.toString()}");
      });
      return doc.id.toString();
    } catch (e) {
      log("error: ${e.toString()}");
      return null;
    }
  }

  static Future<void> getAllTodayMeeting({required BuildContext ctx}) async {
    try {
      //int today =
      DateTime currenDate = DateTime.now();
      DateTime yesterday = currenDate.subtract(Duration(hours: 23));
      QuerySnapshot<Map<String, dynamic>> meetings = await db
          .collection("meetings")
          .where('createdAt', isGreaterThan: Timestamp.fromDate(yesterday))
          .get();
      List<MeetingModel> lstAllMettings =
          meetings.docs.map((el) => MeetingModel.fromMap(el)).toList();
      Provider.of<IghoumaneUserProvider>(ctx, listen: false)
          .initilizeListMeetings(lstAllMettings);
      log("meetings : ${lstAllMettings.toString()}");
    } catch (e) {
      log("error: ${e.toString()}");
    }
  }

  static Future<void> updateMeetingStatus(
      {required String id,
      required String meetingStatus,
      required bool leaveChannel,
      required BuildContext ctx,
      required String userId}) async {
    try {
      if (leaveChannel) {
        await db.collection("meetings").doc(id).update({
          "status": meetingStatus,
          "joinedUsers": FieldValue.arrayRemove([userId])
        }).then((v) {
          getAllTodayMeeting(ctx: ctx);
        });
        log("user leaves status: $meetingStatus");
      } else {
        await db.collection("meetings").doc(id).update({
          "status": meetingStatus,
          "joinedUsers": FieldValue.arrayUnion([userId])
        }).then((v) {
          getAllTodayMeeting(ctx: ctx);
        });
        log("user joined status: $meetingStatus");
      }
    } catch (e) {
      print("fail to update: ${e.toString()}");
      log("Error : ${e.toString()}");
    }
  }
}

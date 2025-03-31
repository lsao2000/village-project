import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/meeting_model.dart';

class MeetingLogicServices {
  static Future<void> createMeeting(
      {required String meetingtoken,
      required List<String> invitedUsers,
      required String currentUserId,
      required String roleType,
      required String meetingStatus,
      required String title,
      required List<String> joinedUsers}) async {
    try {
      DateTime creationDate = DateTime.now();
      await db.collection("meetings").doc().set({
        "createdAt": creationDate,
        "adminId": currentUserId,
        "invitedUsers": FieldValue.arrayUnion(invitedUsers),
        "roleType": roleType,
        "meetingToken": meetingtoken,
        "title": title,
        "status": meetingStatus,
        "joinedUsers": FieldValue.arrayUnion(joinedUsers)
      }).onError((el, e) {
        log("error: ${el.toString()}");
      });
    } catch (e) {
      log("error: ${e.toString()}");
    }
  }

  static Future<void> getAllTodayMeeting({required BuildContext ctx}) async {
    try {
      //int today =
      DateTime currenDate = DateTime.now();
      DateTime yesterday = currenDate.subtract(Duration(hours: 22));
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
}

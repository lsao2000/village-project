import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/freindship_model.dart';
import 'package:village_project/model/user_ighoumane_freind.dart';

class SearchUserServices {
  static Future<QuerySnapshot> searchUsers(
      {required String query, required BuildContext context}) async {
    QuerySnapshot querySnapshot = await db
        .collection("users")
        .where("firstName", isGreaterThanOrEqualTo: query)
        .where("firstName", isLessThanOrEqualTo: "$query\uf8ff")
        // you will use the bellow line for limiting users and get more users with listview controller
        .limit(context.read<IghoumaneUserProvider>().searchItemCount)
        //.orderBy("lastName", descending: true)
        .get();
    return querySnapshot;
  }

  static addNewFreind(
      {required String freindId,
      required BuildContext context,
      required String firstName,
      required String lastName}) async {
    try {
      String currentUserId =
          Provider.of<IghoumaneUserProvider>(context, listen: false)
              .ighoumaneUser
              .getUserId;
      List<String> sortUsersId = [currentUserId, freindId]..sort();
      FreindshipModel freindshipModel = FreindshipModel(
          user1Id: sortUsersId[0],
          user2Id: sortUsersId[1],
          status: "requested");
      await db.collection("users").doc(currentUserId).update({
        "freinds": FieldValue.arrayUnion([freindId])
      });
      await db.collection("freindship").doc().set(freindshipModel.toMap());
      UserIghoumaneFreind userIghoumaneFreind = UserIghoumaneFreind(
          id: freindId, firstName: firstName, lastName: lastName);
      Provider.of<IghoumaneUserProvider>(context,listen: false)
          .addToListFreinds(userIghoumaneFreind);
    } catch (e) {
      log("failed to add freindship  ${e.toString()}");
    }
  }

  static deleteFreind(
      {required BuildContext context, required String freindId}) async {
    try {
      String currentUserId =
          Provider.of<IghoumaneUserProvider>(context, listen: false)
              .ighoumaneUser
              .getUserId;
      List<String> sortUsersId = [currentUserId, freindId]..sort();
      await db.collection("users").doc(currentUserId).update({
        "freinds": FieldValue.arrayRemove([freindId])
      });
      var freindShipModel = await db
          .collection("freindship")
          .where("user1_id", isEqualTo: sortUsersId[0])
          .where("user2_id", isEqualTo: sortUsersId[1])
          .get();
      freindShipModel.docs.first.reference.delete();
      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .updateFreindsIds(id: freindId);
      //await db.collection("freindship")
      log("deleted ");
    } catch (e) {
      log("failed to delete freind ${e.toString()}");
    }
  }
}

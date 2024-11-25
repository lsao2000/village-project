import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/user.dart';

class UsersPostServices {
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    return db.collection("posts").snapshots();
  }

  static updatePostProviderData() {}

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllReactionsOfPost(
      {required String postId}) {
    return db
        .collection("posts")
        .doc(postId)
        .collection("reaction_type")
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCurrentUserPosts(
      {required String userId}) {
    return db
        .collection("posts")
        .where("user_id", isEqualTo: userId)
        .snapshots();
  }

  static Future<IghoumaneUser> getPosterInfo({required String userId}) async {
    var data = await db.collection("users").doc(userId).get();
    IghoumaneUser ighoumaneUser =
        IghoumaneUser.basicInfo(data["firstName"], data["lastName"]);
    return ighoumaneUser;
  }
}

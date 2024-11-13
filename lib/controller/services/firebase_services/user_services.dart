import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/reaction_type.dart';
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
      log("error in updateUser function ${e.toString()}");
    }
  }

  static addPost(
      {required String content, required BuildContext context}) async {
    try {
      String userId = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser
          .getUserId;
      DateTime creationDate = DateTime.now();
      IghoumaneUserPost ighoumaneUserPost = IghoumaneUserPost(
          content: content, userId: userId, createdAt: creationDate);
      await db.collection("posts").doc().set(ighoumaneUserPost.toMap());
      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .updateListPosts(ighoumaneUserPost);
      Navigator.of(context).pop();
    } catch (e) {
      log("failed to add post ${e.toString()}");
    }
  }

  static addLikeToPost(
      {required BuildContext context, required String postId}) async {
    try {
      String userId = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser
          .getUserId;
      ReactionType reactionType =
          ReactionType.addReaction(userId: userId, type: "like");
      var postTable = await db
          .collection("posts")
          .doc(postId)
          .collection("reaction_type")
          .add(reactionType.toMap());
      log(postId);
      //    .doc()
      //    .set(reactionType.toMap());
    } catch (e) {
      log("failed to add like ${e.toString()}");
    }
  }

  static getListPost(
      {required String userId, required BuildContext context}) async {
    try {
      var querySnapshot = await db
          .collection("posts")
          .where("user_id", isEqualTo: userId)
          .get();
      List<IghoumaneUserPost> lstPosts =  querySnapshot.docs.map((el) {
          IghoumaneUserPost ighoumaneUserPost = IghoumaneUserPost.getPostFromQuerySnapshot(el);
           getReactionsTypeFromPost(postId: ighoumaneUserPost.postId!).then((value) async{
               ighoumaneUserPost.setListReactinos = value;
           });
          return  ighoumaneUserPost;
      }).toList();
      //List<IghoumaneUserPost>  newls = lstPosts.map((el) {
      //    el.setListReactinos =  getReactionsTypeFromPost(postId: el.postId!);
      //    return el;
      //}).toList();
      //lstPosts.map((el) async{
      //    el.setListReactinos = await getReactionsTypeFromPost(postId: el.postId!);
      //});
      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .initilizeListPost(lstPosts);
    } catch (e) {
      log("failed to initialize user posts ${e.toString()}");
    }
  }

  static Future<List<ReactionType>> getReactionsTypeFromPost({required String postId}) async {
    var reactionsQuery = await db
        .collection("posts")
        .doc(postId)
        .collection("reaction_type")
        .get();
    List<ReactionType> reactionTypes =  reactionsQuery.docs
        .map((el) => ReactionType.fromQuerySnapshots(reactions: el))
        .toList();
    return  reactionTypes;
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/reaction_type.dart';
import 'package:village_project/model/user.dart';

class UsersPostServices {
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    return db.collection("posts").snapshots();
  }

  static updatePostProviderData() {}

  static Future<void> addPost(
      {required String content, required BuildContext context}) async {
    try {
      String userId = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser
          .getUserId;
      DateTime creationDate = DateTime.now();
      IghoumaneUserPost ighoumaneUserPost = IghoumaneUserPost(
          content: content, userId: userId, createdAt: creationDate);
      await db.collection("posts").add(ighoumaneUserPost.toMap()).then((doc) {
        ighoumaneUserPost.postId = doc.id;
      });

      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .updateListPosts(ighoumaneUserPost);
      Navigator.of(context).pop();
    } catch (e) {
      log("failed to add post ${e.toString()}");
    }
  }

  static Future<void> checkIfReactionExist(
      {required BuildContext context,
      required String postId,
      required String type,
      required String userId}) async {
    try {
      String userId = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser
          .getUserId;
      var reactionsListQuery = await db
          .collection("posts")
          .doc(postId)
          .collection("reaction_type")
          .where("reacter_id", isEqualTo: userId)
          .get();
      if (reactionsListQuery.docs.isEmpty) {
        log("add reaction");
        addReactionToPost(
            context: context, postId: postId, type: type, userId: userId);
      } else {
        var isLikedOrDisliked = reactionsListQuery.docs.first;
        String reactionId = isLikedOrDisliked.id;
        if (isLikedOrDisliked["react_type"] == type) {
          log("delete reaction");
          deleterReactionOfPost(
              context: context,
              postId: postId,
              reactionId: reactionId,
              userId: userId);
        } else {
          updateReactionOfPost(
              context: context,
              postId: postId,
              type: type,
              reactionId: reactionId,
              userId: userId);
          //if (type == "like") {
          log("update ${isLikedOrDisliked["react_type"].toString()} to $type");
          //} else {
          //log("update like to dislike");
          //}
        }
      }
    } catch (e) {
      log("failed to check existing reaction ${e.toString()}");
    }
  }

  static Future<void> deleterReactionOfPost(
      {required BuildContext context,
      required String postId,
      required String reactionId,
      required String userId}) async {
    try {
      await db
          .collection("posts")
          .doc(postId)
          .collection("reaction_type")
          .doc(reactionId)
          .delete();
    } catch (e) {
      log("failed to delete document");
    }
  }

  static Future<void> updateReactionOfPost(
      {required BuildContext context,
      required String postId,
      required String type,
      required String reactionId,
      required String userId}) async {
    try {
      ReactionType reactionType =
          ReactionType.addReaction(userId: userId, type: type);
      await db
          .collection("posts")
          .doc(postId)
          .collection("reaction_type")
          .doc(reactionId)
          .update(reactionType.toMap());
    } catch (e) {
      log("failed to update reaction ${e.toString()}");
    }
  }

  static Future<void> addReactionToPost(
      {required BuildContext context,
      required String postId,
      required String type,
      required String userId}) async {
    try {
      ReactionType reactionType =
          ReactionType.addReaction(userId: userId, type: type);
      await db
          .collection("posts")
          .doc(postId)
          .collection("reaction_type")
          .add(reactionType.toMap());
    } catch (e) {
      log("failed to add like ${e.toString()}");
    }
  }

  static Future<List<ReactionType>> getReactionsTypeFromPost(
      {required BuildContext context, required String id}) async {
    var reactionsQuery =
        await db.collection("posts").doc(id).collection("reaction_type").get();
    List<ReactionType> reactionTypes = reactionsQuery.docs
        .map((el) => ReactionType.fromQuerySnapshots(reactions: el))
        .toList();
    return reactionTypes;
  }

  static deletePost(
      {required BuildContext context,
      required String postId,
      required String userId}) async {
    try {
      var postCollection = db.collection("posts");
      postCollection.doc(postId).delete();
      var lstPosts = await postCollection.get();
      var currentUserPosts =
          await postCollection.where("user_id", isEqualTo: userId).get();
      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .initilizeCurrentUserPosts(currentUserPosts.docs
              .map((el) => IghoumaneUserPost.getPostFromQuerySnapshot(el))
              .toList());
      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .initilizeListPost(lstPosts.docs
              .map((el) => IghoumaneUserPost.getPostFromQuerySnapshot(el))
              .toList());
    } catch (e) {
      log("failed to delete post ${e.toString()}");
    }
  }
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

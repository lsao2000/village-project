import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/reaction_type.dart';

class IghoumaneUserPost {
  late String _content;
  late String _userId;
  late DateTime _createdAt;
  List<ReactionType> _lstReaction = [];
  String? postId;
  IghoumaneUserPost({
    required String content,
    required String userId,
    required DateTime createdAt,
  })  : _content = content,
        _userId = userId,
        _createdAt = createdAt;
  Map<String, dynamic> toMap() {
    return {
      "user_id": _userId,
      "content": _content,
      "created_at": _createdAt,
    };
  }

  IghoumaneUserPost.getPostFromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> post) {
    _userId = post["user_id"];
    _content = post["content"];
    postId = post.id;
    Timestamp postDate = post["created_at"];
    _createdAt = postDate.toDate();
  }
  getReactionsTypeFromQuery(
      QueryDocumentSnapshot<Map<String, dynamic>> reactions) {
    ReactionType reactionType = ReactionType.addReaction(
        userId: reactions["reacter_id"], type: reactions["react_type"]);
    _lstReaction.add(reactionType);
  }
  updateReactions(BuildContext context, String id) async{
    _lstReaction = await UserServices.getReactionsTypeFromPost(context: context, id: id);
  }

  set setListReactinos(List<ReactionType> lstReactions) {
    _lstReaction = lstReactions;
  }

  List<ReactionType> get getLstReactions => _lstReaction;
  get getContent => _content;
  get getUserId => _userId;
  get getCreatedAt => _createdAt;
}

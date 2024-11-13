import 'package:cloud_firestore/cloud_firestore.dart';
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
  set setListReactinos(List<ReactionType> lstReactions) {
    _lstReaction = lstReactions;
  }

  List<ReactionType> get getLstReactions => _lstReaction;
  get getContent => _content;
  get getUserId => _userId;
  get getCreatedAt => _createdAt;
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ReactionType {
  String? _userId;
  String? _type;
  ReactionType();
  Map<String, dynamic> toMap() {
    return {"reacter_id": _userId, "react_type": _type};
  }

  ReactionType.addReaction({required String userId, required String type})
      : _type = type,
        _userId = userId;
  ReactionType.fromQuerySnapshots({ required
      QueryDocumentSnapshot<Map<String, dynamic>> reactions}) {
    _type = reactions["react_type"];
    _userId = reactions["reacter_id"];
  }
  get getUserId => _userId;
  get getType => _type;
}

import 'package:flutter/material.dart';
import 'package:village_project/model/joined_user.dart';

class JoinedUserProvider extends ChangeNotifier {
  late JoinedUser joinedUser;
  void intilizeJoinedUser(JoinedUser joinedUser, String id) {
    this.joinedUser = joinedUser;
    this.joinedUser.setUserId = id;
    notifyListeners();
  }
}

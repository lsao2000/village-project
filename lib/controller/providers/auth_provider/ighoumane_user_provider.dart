import 'package:flutter/material.dart';
import 'package:village_project/model/freind_model.dart';
import 'package:village_project/model/post_model.dart';
import 'package:village_project/model/user.dart';

class IghoumaneUserProvider extends ChangeNotifier {
  late IghoumaneUser ighoumaneUser;
  late List<PostModel> lstPosts;
  late List<FreindModel> lstFreinds;
  IghoumaneUserProvider() {
    initilizeListFreinds([]);
    initilizeListPost([]);
  }
  void initilizeIghoumaneUser(IghoumaneUser ighoumaneUser) {
    this.ighoumaneUser = ighoumaneUser;
    notifyListeners();
  }

  void initilizeListPost(List<PostModel> lstPosts) {
    this.lstPosts = lstPosts;
    notifyListeners();
  }

  void initilizeListFreinds(List<FreindModel> lstFreinds) {
    this.lstFreinds = lstFreinds;
    notifyListeners();
  }

  void updateListPosts(PostModel postModel) {
    lstPosts.add(postModel);
    notifyListeners();
  }

  void updateListFreinds(FreindModel freindModel) {
    lstFreinds.add(freindModel);
    notifyListeners();
  }
}

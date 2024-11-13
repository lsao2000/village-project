import 'package:flutter/material.dart';
import 'package:village_project/model/freind_model.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/post_model.dart';
import 'package:village_project/model/user.dart';

class IghoumaneUserProvider extends ChangeNotifier {
  late IghoumaneUser ighoumaneUser;
  late List<IghoumaneUserPost> lstPosts;
  late List<FreindModel> lstFreinds;
  IghoumaneUserProvider() {
    initilizeListFreinds([]);
  }
  void updateIghoumaneUser(IghoumaneUser ighoumaneUser){
      this.ighoumaneUser = ighoumaneUser;
      notifyListeners();
  }
  void initilizeIghoumaneUser(IghoumaneUser ighoumaneUser) {
    this.ighoumaneUser = ighoumaneUser;
    notifyListeners();
  }

  void initilizeListPost(List<IghoumaneUserPost> lstPosts) {
    this.lstPosts = lstPosts;
    notifyListeners();
  }

  void initilizeListFreinds(List<FreindModel> lstFreinds) {
    this.lstFreinds = lstFreinds;
    notifyListeners();
  }

  void updateListPosts(IghoumaneUserPost  ighoumaneUserPost) {
    lstPosts.add(ighoumaneUserPost);
    notifyListeners();
  }

  void updateListFreinds(FreindModel freindModel) {
    lstFreinds.add(freindModel);
    notifyListeners();
  }
  //void updatePostReaction({required int index, List<}){
  //    IghoumaneUserPost ighoumaneUserPost = lstPosts[index];
  //    ighoumaneUserPost.setListReactinos =
  //
  //    notifyListeners();
  //}
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/freind_model.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/reaction_type.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/model/user_ighoumane_freind.dart';

class IghoumaneUserProvider extends ChangeNotifier {
  late IghoumaneUser ighoumaneUser;
  List<IghoumaneUserPost>? lstAllPosts;
  late List<UserIghoumaneFreind> lstFreinds;
  int searchItemCount = 20;
  IghoumaneUserProvider() {
    initilizeListFreinds([]);
  }
  Future<void> startLiseningToUsrPost(BuildContext context) async {
    db.collection("posts").snapshots().listen((snapshot) async {
      await initilizeListPost(
          snapshot.docs.map((el) {
            return IghoumaneUserPost.getPostFromQuerySnapshot(el);
          }).toList(),
          context);
      //await  UserServices.getReactionsTypeFromPost(context: context);
      notifyListeners();
    });
  }

  void updateFreindsIds({required String id}) {
    lstFreinds.removeWhere((item) => item.getId == id);
    ighoumaneUser.getLstFreindsIds.removeWhere((item) => item == id);
    notifyListeners();
  }

  void initilizeIghoumaneUser(IghoumaneUser ighoumaneUser) {
    this.ighoumaneUser = ighoumaneUser;
    notifyListeners();
  }

  Future<void> initilizeListPost(
      List<IghoumaneUserPost> lstPosts, BuildContext context) async {
    lstAllPosts = lstPosts;
    notifyListeners();
  }

  void initilizeListFreinds(List<UserIghoumaneFreind> lstFreinds) {
    this.lstFreinds = lstFreinds;
    notifyListeners();
  }

  void getPostReactions(List<ReactionType> lstReactions, int index) {
    IghoumaneUserPost post = lstAllPosts![index];
    post.setListReactinos = lstReactions;
    notifyListeners();
  }

  void updateIghoumaneUser(IghoumaneUser ighoumaneUser) {
    this.ighoumaneUser = ighoumaneUser;
    notifyListeners();
  }

  void updateIghoumaneUserLstFreindIds({required List<String> lstFreindIds}) {
    ighoumaneUser.setLstFreindIds = lstFreindIds;
    notifyListeners();
  }

  void updateListPosts(IghoumaneUserPost ighoumaneUserPost) {
    lstAllPosts!.add(ighoumaneUserPost);
    notifyListeners();
  }

  void addToListFreinds(UserIghoumaneFreind freindModel) {
    lstFreinds.add(freindModel);
    ighoumaneUser.getLstFreindsIds.add(freindModel.getId);
    notifyListeners();
  }

  void updateSearchItemCount() {
    searchItemCount += 20;
    notifyListeners();
  }
}

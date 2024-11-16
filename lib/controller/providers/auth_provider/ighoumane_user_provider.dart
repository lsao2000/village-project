import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/freind_model.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/reaction_type.dart';
import 'package:village_project/model/user.dart';

class IghoumaneUserProvider extends ChangeNotifier {
  late IghoumaneUser ighoumaneUser;
  List<IghoumaneUserPost>? lstAllPosts;
  late List<FreindModel> lstFreinds;
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

  void updateIghoumaneUser(IghoumaneUser ighoumaneUser) {
    this.ighoumaneUser = ighoumaneUser;
    notifyListeners();
  }

  void initilizeIghoumaneUser(IghoumaneUser ighoumaneUser) {
    this.ighoumaneUser = ighoumaneUser;
    notifyListeners();
  }

  Future<void> initilizeListPost(
      List<IghoumaneUserPost> lstPosts, BuildContext context) async {
    lstAllPosts = lstPosts;
    //lstAllPosts!.map((el) async {
      //var reactionsQuery = await db
      //    .collection("posts")
      //    .doc(el.postId)
      //    .collection("reaction_type")
      //    .snapshots()
      //    .listen((snapshot) {
      //  List<ReactionType> reactionTypes = snapshot.docs
      //      .map((el) => ReactionType.fromQuerySnapshots(reactions: el))
      //      .toList();
      //  el.setListReactinos = reactionTypes;
        //notifyListeners();
      //});
    //});
    //db.collection("posts").doc
    notifyListeners();
  }

  void getPostReactions(List<ReactionType> lstReactions, int index) {
    IghoumaneUserPost post = lstAllPosts![index];
    post.setListReactinos = lstReactions;
    notifyListeners();
  }

  void initilizeListFreinds(List<FreindModel> lstFreinds) {
    this.lstFreinds = lstFreinds;
    notifyListeners();
  }

  void updateListPosts(IghoumaneUserPost ighoumaneUserPost) {
    lstAllPosts!.add(ighoumaneUserPost);
    notifyListeners();
  }

  void updateListFreinds(FreindModel freindModel) {
    lstFreinds.add(freindModel);
    notifyListeners();
  }
}

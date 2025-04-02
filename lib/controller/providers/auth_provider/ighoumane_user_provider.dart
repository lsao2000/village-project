import 'package:flutter/material.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/meeting_model.dart';
import 'package:village_project/model/reaction_type.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/model/user_ighoumane_freind.dart';

class IghoumaneUserProvider extends ChangeNotifier {
  late IghoumaneUser ighoumaneUser;
  List<IghoumaneUserPost>? lstAllPosts;
  late List<UserIghoumaneFreind> lstFreinds;
  late List<IghoumaneUserPost> currentUserPosts;
  late List<MeetingModel> lstMeetings;
  int searchItemCount = 20;
  IghoumaneUserProvider() {
    initilizeListFreinds([]);
  }

  void initilizeListMeetings(List<MeetingModel> list) {
    lstMeetings = list;
    notifyListeners();
  }

  void updateListMeetings(List<MeetingModel> newList) {
    newList = lstMeetings;
    notifyListeners();
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

  void initilizeCurrentUserPosts(List<IghoumaneUserPost> lstPosts) {
    currentUserPosts = lstPosts;
    notifyListeners();
  }

  void deletePost({required String deletedPostId}) {
    currentUserPosts.removeWhere(
      (element) => element.postId == deletedPostId,
    );
    lstAllPosts?.removeWhere(
      (element) => element.postId == deletedPostId,
    );
    notifyListeners();
  }

  Future<void> initilizeListPost(List<IghoumaneUserPost> lstPosts) async {
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
    lstAllPosts!.insert(0, ighoumaneUserPost);
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

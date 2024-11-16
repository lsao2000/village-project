import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/post_services/users_post_services.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/reaction_type.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/nav_bar_screens/home/add_post_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  late IghoumaneUserProvider ighoumaneUserProvider;
  List<IghoumaneUserPost>? lstPosts;
  @override
  void initState() {
    super.initState();
    ighoumaneUserProvider =
        Provider.of<IghoumaneUserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<IghoumaneUserProvider>(
        builder: (context, value, child) {
          if (value.lstAllPosts == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: deepBlue,
              ),
            );
          }
          return getPostsScreen(
              postCount: value.lstAllPosts!.length,
              height: height,
              width: width);
          //return ListView.builder(
          //    itemCount: value.lstAllPosts!.length,
          //    itemBuilder: (context, index) {
          //      //return Text("hell");
          //    });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: deepBlueDark,
        onPressed: () async {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (ctx) => const AddPostScreen()));
        },
        child: const Text(
          "Post",
          style: TextStyle(
              color: white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget getPostsScreen(
      {required int postCount, required double height, required double width}) {
    return ListView.builder(
      itemCount: postCount,
      itemBuilder: (ctx, index) {
        IghoumaneUserPost ighoumaneUserPost =
            ighoumaneUserProvider.lstAllPosts![index];
        return Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: deepBlue))),
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.4),
                    child: Image(
                      fit: BoxFit.cover,
                      image: const AssetImage("assets/images/youghmane.png"),
                      width: width * 0.1,
                      height: height * 0.05,
                    ),
                  ),
                  SizedBox(
                    width: height * 0.01,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ighoumaneUserProvider.ighoumaneUser.getFirstName} ${ighoumaneUserProvider.ighoumaneUser.getLastName}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          getDateFormat(ighoumaneUserPost.getCreatedAt),
                          //"ls",
                          style: const TextStyle(
                              color: black38,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  //PopupMenuButton(
                  //    icon: const Icon(Icons.more_vert),
                  //    onSelected: (value) {
                  //      if (value == "delete") {
                  //        log("delete post");
                  //        String postId = ighoumaneUserPost.postId!;
                  //        UserServices.deletePost(
                  //            context: context, postId: postId);
                  //      }
                  //    },
                  //    itemBuilder: (context) => [
                  //          PopupMenuItem(
                  //            value: "delete",
                  //            child: const ListTile(
                  //              title: Text('Delete'),
                  //              //trailing: Icon(Icons),
                  //              contentPadding: EdgeInsets.zero,
                  //            ),
                  //            onTap: () {},
                  //          )
                  //        ]),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: ighoumaneUserPost.getContent,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        )),
                  ]),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              StreamBuilder(
                stream: UsersPostServices.getAllReactionsOfPost(
                    postId: ighoumaneUserPost.postId!),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<ReactionType> lstReactions = snapshot.data!.docs
                        .map((el) =>
                            ReactionType.fromQuerySnapshots(reactions: el))
                        .toList();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.008, left: width * 0.01),
                          child: Text(
                            "${lstReactions.where((el) => el.getType == "like").length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        InkWell(
                          onTap: () async {
                            String postId = ighoumaneUserPost.postId!;
                            UserServices.checkIfReactionExist(
                                context: context,
                                postId: postId,
                                type: "like",
                                userId: ighoumaneUserProvider
                                    .ighoumaneUser.getUserId);
                          },
                          child: Icon(
                            Icons.thumb_up,
                            color: isLikeOrDislike("like", lstReactions)
                                ? deepBlue
                                : black,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.08,
                        ),
                        Text(
                          "${lstReactions.where((el) => el.getType == "dislike").length}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            String postId = ighoumaneUserPost.postId!;
                            UserServices.checkIfReactionExist(
                                context: context,
                                postId: postId,
                                type: "dislike",
                                userId: ighoumaneUserProvider
                                    .ighoumaneUser.getUserId);
                          },
                          child: Icon(
                            Icons.thumb_down,
                            color: isLikeOrDislike("dislike", lstReactions)
                                ? desertOrange
                                : black,
                          ),
                        )
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: height * 0.008, left: width * 0.01),
                        child: const Text(
                          "0",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () async {
                          String postId = ighoumaneUserPost.postId!;
                          UserServices.checkIfReactionExist(
                              context: context,
                              postId: postId,
                              type: "like",
                              userId: ighoumaneUserProvider
                                  .ighoumaneUser.getUserId);
                        },
                        child: const Icon(
                          Icons.thumb_up,
                          color: black,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      const Text(
                        "0",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          String postId = ighoumaneUserPost.postId!;
                          UserServices.checkIfReactionExist(
                              context: context,
                              postId: postId,
                              type: "dislike",
                              userId: ighoumaneUserProvider
                                  .ighoumaneUser.getUserId);
                        },
                        child: const Icon(
                          Icons.thumb_down,
                          color: black,
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getDateFormat(DateTime dateFormated) {
    IghoumaneUser ighoumaneUser =
        Provider.of<IghoumaneUserProvider>(context).ighoumaneUser;
    int year = ighoumaneUser.getCreatedDate.year;
    int month = ighoumaneUser.getCreatedDate.month;
    String day = ighoumaneUser.getCreatedDate.day > 9
        ? ighoumaneUser.getCreatedDate.day.toString()
        : "0${ighoumaneUser.getCreatedDate.day}";
    return "$day-$month-$year";
  }

  int getLikeCount(IghoumaneUserPost ighoumaneUserPost) {
    var ls = ighoumaneUserPost.getLstReactions
        .where((el) => el.getType == "like")
        .toList();
    return ls.length;
  }

  int getDislikeCount(IghoumaneUserPost ighoumaneUserPost) {
    var ls = ighoumaneUserPost.getLstReactions
        .where((el) => el.getType == "like")
        .toList();
    return ls.length;
  }

  bool isLikeOrDislike(String type, List<ReactionType> lstReactions) {
    var reacted = lstReactions
        .where((el) =>
            el.getUserId == ighoumaneUserProvider.ighoumaneUser.getUserId)
        .toList();
    if (reacted.isEmpty) {
      return false;
    }
    return reacted.first.getType == type;
  }
}

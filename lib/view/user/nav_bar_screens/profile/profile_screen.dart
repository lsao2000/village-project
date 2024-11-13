import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/nav_bar_screens/profile/update_user_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late String id;
  List<IghoumaneUserPost> lstPosts = [];
  late IghoumaneUserProvider ighoumaneUserProvider;
  @override
  void initState() {
    setState(() {
      ighoumaneUserProvider =
          Provider.of<IghoumaneUserProvider>(context, listen: false);
      lstPosts = ighoumaneUserProvider.lstPosts;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //IghoumaneUserProvider  ighoumaneUserProvider = Provider.of<IghoumaneUserProvider>(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * .03),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.2),
                        child: Image(
                          fit: BoxFit.fill,
                          image:
                              const AssetImage("assets/images/youghmane.png"),
                          width: width * 0.2,
                          height: height * 0.1,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            // Navigate to the new screen without the persistent navbar
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateUserInfoScreen()),
                            );
                          },
                          child: const Icon(
                            Icons.settings,
                            color: deepBlueDark,
                          ),
                        ),
                      )
                    ],
                  ),
                  Usefulfunctions.blankSpace(width: width * 0.3, height: 0),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: const TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text:
                                    "${ighoumaneUserProvider.lstPosts.length}\n"),
                            const TextSpan(text: "Posts"),
                          ])),
                  Usefulfunctions.blankSpace(width: width * 0.1, height: 0),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: const TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text:
                                    "${ighoumaneUserProvider.lstFreinds.length}\n"),
                            const TextSpan(text: "Freinds"),
                          ])),
                ],
              ),
              Usefulfunctions.blankSpace(height: height * 0.01, width: 0),
              Text(
                maxLines: 1,
                "${ighoumaneUserProvider.ighoumaneUser.getFirstName} ${ighoumaneUserProvider.ighoumaneUser.getLastName}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: getDateFormat(
                          ighoumaneUserProvider.ighoumaneUser.getCreatedDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black26,
                      ),
                    ),
                  ],
                ),
              ),
              Usefulfunctions.blankSpace(height: height * 0.01, width: 0),
              SizedBox(
                width: width * 0.7,
                child: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.parent,
                  text: TextSpan(children: [
                    TextSpan(
                        text: ighoumaneUserProvider
                                .ighoumaneUser.getDescription.isEmpty
                            ? "no description"
                            : ighoumaneUserProvider
                                .ighoumaneUser.getDescription,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis, color: black))
                  ]),
                ),
              ),
              Usefulfunctions.blankSpace(height: height * 0.01, width: 0),
            ],
          ),
        ),
        Builder(builder: (ctx) {
          int postCount = ighoumaneUserProvider.lstPosts.length;
          if (postCount == 0) {
            return Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "No post",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black12,
                      fontSize: width * 0.1),
                ),
              ),
            );
          }
          return getPostsScreen(
              postCount: postCount, height: height, width: width);
        }),
      ],
    );
  }

  getId() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      id = user.uid;
    } catch (e) {
      print("error geting id ${e.toString()}");
    }
  }

  Widget getPostsScreen(
      {required int postCount, required double height, required double width}) {
    return Expanded(
      child: ListView.builder(
          itemCount: postCount,
          itemBuilder: (ctx, index) {
            IghoumaneUserPost ighoumaneUserPost = lstPosts[index];
            var ls = lstPosts[index]
                .getLstReactions
                .where((el) =>
                    el.getUserId ==
                    ighoumaneUserProvider.ighoumaneUser.getUserId)
                .toList();
            bool isLiked =
                ls.isNotEmpty && ls.first.getType == "like" ? true : false;
            bool isDisliked =
                ls.isNotEmpty && ls.first.getType == "dilike" ? true : false;
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
                          image:
                              const AssetImage("assets/images/youghmane.png"),
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
                              style: const TextStyle(
                                  color: black38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {},
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: "delete",
                                  child: const ListTile(
                                    title: Text('Delete'),
                                    trailing: Icon(Icons.remove),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onTap: () {},
                                )
                              ]),
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
                            //text: ighoumaneUserPost.postId,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: height * 0.008, left: width * 0.01),
                        child: Text(
                         "${getLikeCount(index)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          isLiked = !isLiked;
                          String postId = ighoumaneUserPost.postId!;
                          //UserServices.addLikeToPost(context: context, postId: postId);
                          isLiked ? log("like") : log("delete like");
                        },
                        child: Icon(
                          Icons.thumb_up,
                          color: isLiked ? deepBlue : black,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
                      ),
                       Text(
                       "${getDislikeCount(index)}",
                        //"${postModel.getDislike}",
                        style:const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          isDisliked = !isDisliked;
                          isDisliked ? log("dislike") : log("delete dislike");
                        },
                        child: Icon(
                          Icons.thumb_down,
                          color: isDisliked ? desertOrange : black,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }),
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

  int getLikeCount(int index) {
    var ls = lstPosts[index]
        .getLstReactions
        .where((el) => el.getType == "like")
        .toList();
    return ls.length;
  }

  int getDislikeCount(int index) {
    var ls = lstPosts[index]
        .getLstReactions
        .where((el) => el.getType == "dilike")
        .toList();
    return ls.length;
  }
}

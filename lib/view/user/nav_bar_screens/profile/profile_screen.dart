import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/post_services/users_post_services.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/reaction_type.dart';
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
  //List<IghoumaneUserPost> lstPosts = [];
  late IghoumaneUserProvider ighoumaneUserProvider;
  @override
  void initState() {
    setState(() {
      //ighoumaneUserProvider =
      //    Provider.of<IghoumaneUserProvider>(context);
      //lstPosts = ighoumaneUserProvider.lstPosts;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ighoumaneUserProvider = Provider.of<IghoumaneUserProvider>(context);
    IghoumaneUser ighoumaneUser = ighoumaneUserProvider.ighoumaneUser;
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
                                    //"${ighoumaneUser.getLstFreindsIds.length}",),
                                    "${ighoumaneUserProvider.currentUserPosts.length}\n"),
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
                                  "${ighoumaneUser.getLstFreindsIds.length}\n",
                            ),
                            //"${ighoumaneUserProvider.lstFreinds.length}\n"),
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
        // post section for displaying all post of current user.
        Builder(builder: (ctx) {
          //int postCount = ighoumaneUserProvider.lstAllPosts
          //        ?.where((el) => el.getUserId == ighoumaneUser.getUserId)
          //        .toList()
          //        .length ??
          //    0;
          int postCount = ighoumaneUserProvider.currentUserPosts.length;
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

          return getPosts(
              userId: ighoumaneUser.getUserId, height: height, width: width);
          //return getPostsScreenOld(postCount: postCount, height: height, width: width);
          //return getPostsScreen(
          //    postCount: postCount, height: height, width: width);
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

  int getLikeCountOld(int index) {
    var ls = ighoumaneUserProvider.lstAllPosts![index].getLstReactions
        .where((el) => el.getType == "like")
        .toList();
    return ls.length;
  }

  int getDislikeCount(int index) {
    var ls = ighoumaneUserProvider.lstAllPosts![index].getLstReactions
        .where((el) => el.getType == "dislike")
        .toList();
    return ls.length;
  }

  bool isLikeOrDislike(String type, List<ReactionType> lstReactions) {
    //print(lstReactionsType.length.toString());
    //print(lstReactionsType.contains(ReactionType.addReaction(userId: ighoumaneUserPost.getUserId, type: type)));
    var reacted = lstReactions
        .where((el) =>
            el.getUserId == ighoumaneUserProvider.ighoumaneUser.getUserId)
        .toList();
    if (reacted.isEmpty) {
      return false;
    }
    return reacted.first.getType == type;
  }

  Widget getPosts(
      {required String userId, required double height, required double width}) {
    return Expanded(
        child: StreamBuilder(
            stream: UsersPostServices.getCurrentUserPosts(userId: userId),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                List<IghoumaneUserPost> lstPosts = snapshot.data!.docs
                    .map((el) => IghoumaneUserPost.getPostFromQuerySnapshot(el))
                    .toList();
                return ListView.builder(
                    itemCount: lstPosts.length,
                    itemBuilder: (ctx, index) {
                      IghoumaneUserPost ighoumaneUserPost = lstPosts[index];
                      return Container(
                        decoration: const BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: deepBlue))),
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.01, horizontal: width * .03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.4),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: const AssetImage(
                                        "assets/images/youghmane.png"),
                                    width: width * 0.1,
                                    height: height * 0.05,
                                  ),
                                ),
                                SizedBox(
                                  width: height * 0.01,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${ighoumaneUserProvider.ighoumaneUser.getFirstName} ${ighoumaneUserProvider.ighoumaneUser.getLastName}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        getDateFormat(
                                            ighoumaneUserPost.getCreatedAt),
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
                                    onSelected: (value) {
                                      if (value == "delete") {
                                        log("delete post");
                                        //String userId
                                        String postId =
                                            ighoumaneUserPost.postId!;
                                        UsersPostServices.deletePost(
                                            context: context,
                                            postId: postId,
                                            userId: userId);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: "delete",
                                            child: const ListTile(
                                              title: Text('Delete'),
                                              //trailing: Icon(Icons),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01),
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
                                stream: db
                                    .collection("posts")
                                    .doc(ighoumaneUserPost.postId)
                                    .collection("reaction_type")
                                    .snapshots(),
                                builder: (ctx, snapshot) {
                                  //Map<String, dynamic> reaction = snapshot.data!.docs.first.data();
                                  if (snapshot.hasData) {
                                    //return Text("cant get data right now");
                                    //print(lstReactionsType.contains(ReactionType.addReaction(userId: ighoumaneUserPost.getUserId, type: type)));
                                    List<ReactionType> lstReactions = snapshot
                                        .data!.docs
                                        .map((el) =>
                                            ReactionType.fromQuerySnapshots(
                                                reactions: el))
                                        .toList();
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.008,
                                              left: width * 0.01),
                                          child: Text(
                                            "${lstReactions.where((el) => el.getType == "like").length ?? 0}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            //List<ReactionType> lstReactions = snapshot.data!.docs.map((el) => ReactionType.fromQuerySnapshots(reactions: el) ).toList();
                                            //Map<String, dynamic> reaction = snapshot.data!.docs.first.data();
                                            //isLiked = !isLiked;
                                            String postId =
                                                ighoumaneUserPost.postId!;
                                            //log(ighoumaneUserPost.getLstReactions.length.toString());
                                            //var posts = await db.collection("posts").doc(postId).get() ;
                                            log(lstReactions.length.toString());
                                            isLikeOrDislike(
                                                "dislike", lstReactions);
                                            UsersPostServices.checkIfReactionExist(
                                                context: context,
                                                postId: postId,
                                                type: "like",
                                                userId: ighoumaneUserProvider
                                                    .ighoumaneUser.getUserId);
                                          },
                                          child: Icon(
                                            Icons.thumb_up,
                                            color: isLikeOrDislike(
                                                    "like", lstReactions)
                                                ? deepBlue
                                                : black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.08,
                                        ),
                                        Text(
                                          "${lstReactions.where((el) => el.getType == "dislike").length ?? 0}",
                                          //"${getDislikeCount(index)}",
                                          //"${postModel.getDislike}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            String postId =
                                                ighoumaneUserPost.postId!;
                                            UsersPostServices.checkIfReactionExist(
                                                context: context,
                                                postId: postId,
                                                type: "dislike",
                                                userId: ighoumaneUserProvider
                                                    .ighoumaneUser.getUserId);
                                            //isDisliked ? log("dislike") : log("delete dislike");
                                          },
                                          child: Icon(
                                            Icons.thumb_down,
                                            color: isLikeOrDislike(
                                                    "dislike", lstReactions)
                                                ? desertOrange
                                                : black,
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.008,
                                              left: width * 0.01),
                                          child: const Text(
                                            "0",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            String postId =
                                                ighoumaneUserPost.postId!;
                                            //log(ighoumaneUserPost.getLstReactions.length.toString());
                                            //var posts = await db.collection("posts").doc(postId).get() ;
                                            UsersPostServices.checkIfReactionExist(
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
                                          //"${postModel.getDislike}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            String postId =
                                                ighoumaneUserPost.postId!;
                                            UsersPostServices.checkIfReactionExist(
                                                context: context,
                                                postId: postId,
                                                type: "dislike",
                                                userId: ighoumaneUserProvider
                                                    .ighoumaneUser.getUserId);
                                            //isDisliked ? log("dislike") : log("delete dislike");
                                          },
                                          child: const Icon(
                                            Icons.thumb_down,
                                            color: black,
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                }),
                          ],
                        ),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: deepBlue,
                  ),
                );
              }
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "No post",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black12,
                      fontSize: width * 0.1),
                ),
              );
            }));
  }
}

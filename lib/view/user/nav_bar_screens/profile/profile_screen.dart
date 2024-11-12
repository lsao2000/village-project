import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
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
  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    IghoumaneUserProvider ighoumaneUserProvider =
        Provider.of<IghoumaneUserProvider>(context);
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
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            //Navigator.push(
                            //    context,
                            //    MaterialPageRoute(
                            //        builder: (ctx) => NewScreen()));
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
                //id,
                "${ighoumaneUserProvider.ighoumaneUser?.getFirstName} ${ighoumaneUserProvider.ighoumaneUser?.getLastName}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      //text: "",
                      text: getDateFormat(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black26,
                        //fontSize: 11
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
                  //maxLines: ,
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
          return getPostsScreen(postCount: postCount, height: height);
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

  Widget getPostsScreen({required int postCount, required double height}) {
    return Expanded(
      child: ListView.builder(
          itemCount: postCount,
          itemBuilder: (ctx, index) {
            return Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: black))),
              padding: EdgeInsets.symmetric(vertical: height * 0.1),
              child: Center(
                child: Text(
                  "post number ${index + 1}",
                ),
              ),
            );
          }),
    );
  }

  String getDateFormat() {
    IghoumaneUser ighoumaneUser =
        Provider.of<IghoumaneUserProvider>(context).ighoumaneUser;
    int year = ighoumaneUser.getCreatedDate.year;
    int month = ighoumaneUser.getCreatedDate.month;
    String day = ighoumaneUser.getCreatedDate.day > 9
        ? ighoumaneUser.getCreatedDate.day.toString()
        : "0${ighoumaneUser.getCreatedDate.day}";
    return "$day-$month-$year";
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/auth_services/auth_services.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/auth_screen/auth_screen.dart';
import 'package:village_project/view/user/nav_bar_screens/chat/chat_screen.dart';
import 'package:village_project/view/user/nav_bar_screens/discussins/discussions_screen.dart';
import 'package:village_project/view/user/nav_bar_screens/home/home.dart';
import 'package:village_project/view/user/nav_bar_screens/meeting/meeting_screen.dart';
import 'package:village_project/view/user/nav_bar_screens/profile/profile_screen.dart';
import 'package:village_project/view/user/nav_bar_screens/search/search_screen.dart';

class UserBottomNavBar extends StatefulWidget {
  const UserBottomNavBar({super.key});
  @override
  State<StatefulWidget> createState() => UserBottomNavBarState();
}

class UserBottomNavBarState extends State<UserBottomNavBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  late final StreamSubscription<User?> listening;
  @override
  void initState() {
    AuthServices.intilizeIghoumaneUser(context);

    listening = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      try {
        if (user == null) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (ctx) => const AuthScreen()),
              (route) => false);
        }
      } catch (e) {
        log("error in disposing ${e.toString()}");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    //listening.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var ighoumaneUserProvider = Provider.of<IghoumaneUserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: const Text(
            "Ighoumane",
            style: TextStyle(
                color: deepBlueDark, fontFamily: "Baloo2", fontSize: 30),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchScreen());
                },
                icon: Icon(
                  Icons.search,
                  size: width * 0.08,
                )),
            Container(
              margin: EdgeInsets.only(right: width * 0.03, left: width * 0.01),
              child: Stack(
                children: [
                  Positioned(
                    child: Icon(
                      Icons.notifications,
                      size: width * 0.08,
                    ),
                  ),
                  Positioned(
                    top: -7,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.01),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: deepBlueDark),
                      child: const Text(
                        "2",
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: PersistentTabView(
          context,
          screens: _buildScreens(),
          items: _navBarItems(),
          controller: _controller,
          backgroundColor: deepBlueDark,
          navBarHeight: 65,
        ));
  }

  List<Widget> _buildScreens() {
    return [
      const Home(),
      const DiscussionsScreen(),
      const MeetingScreen(),
      const ChatScreen(),
      const ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "home",
          activeColorPrimary: white,
          inactiveColorPrimary: lowWhite),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.people),
          title: "Discussions",
          activeColorPrimary: white,
          inactiveColorPrimary: lowWhite),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.phone_in_talk),
          title: "Meeting",
          activeColorPrimary: white,
          inactiveColorPrimary: lowWhite),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat),
          title: "Chat",
          activeColorPrimary: white,
          inactiveColorPrimary: lowWhite),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Profile",
          activeColorPrimary: white,
          inactiveColorPrimary: lowWhite),
    ];
  }
}

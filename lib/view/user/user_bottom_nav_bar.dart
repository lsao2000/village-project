import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/chat_screen.dart';
import 'package:village_project/view/user/discussions_screen.dart';
import 'package:village_project/view/user/home.dart';
import 'package:village_project/view/user/meeting_screen.dart';
import 'package:village_project/view/user/profile_screen.dart';

class UserBottomNavBar extends StatefulWidget {
    const UserBottomNavBar({super.key});
  @override
  State<StatefulWidget> createState() => UserBottomNavBarState();
}

class UserBottomNavBarState extends State<UserBottomNavBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarItems(),
      controller: _controller,
      backgroundColor: deepBlue,
    );
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
        inactiveColorPrimary:lowWhite
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        title: "Discussions",
        activeColorPrimary: white,
        inactiveColorPrimary:lowWhite
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.meeting_room),
        title: "Meeting",
        activeColorPrimary: white,
        inactiveColorPrimary:lowWhite
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        title: "Chat",
        activeColorPrimary: white,
        inactiveColorPrimary:lowWhite
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: white,
        inactiveColorPrimary:lowWhite
      ),
    ];
  }
}

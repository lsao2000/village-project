import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:village_project/controller/services/auth_services/auth_services.dart';
import 'package:village_project/view/auth_screen/auth_screen.dart';
import 'package:village_project/view/user/user_bottom_nav_bar.dart';

class Signinlogic extends StatefulWidget {
  const Signinlogic({super.key});
  @override
  State<StatefulWidget> createState() => SigninlogicState();
}

class SigninlogicState extends State<Signinlogic> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfUserLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return const Text("");
  }

  checkIfUserLogin() {
    bool isLogin = AuthServices.checkAuthentication();
    try {
      isLogin
          ? Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const UserBottomNavBar(),
                  type: PageTransitionType.scale,
                  alignment: Alignment.center),
              (route) => false)
          : Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const AuthScreen(),
                  type: PageTransitionType.rightToLeftJoined),
              (route) => false);
    } catch (e) {
      log("failed removing not existing widget ${e.toString()}");
    }
  }
}

import 'package:flutter/material.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfUserLogin();
    });
    //checkIfUserLogin();
  }

  @override
  Widget build(BuildContext context) {
      return Placeholder();
  }

  checkIfUserLogin() {
    bool isLogin = AuthServices.checkAuthentication();
    isLogin
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const UserBottomNavBar()),
            (route) => false)
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const AuthScreen()),
            (route) => false);
  }
}

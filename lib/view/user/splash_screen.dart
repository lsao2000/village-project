import 'dart:async';

import 'package:flutter/material.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/user_bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image(
              fit: BoxFit.cover,
              image: const AssetImage("assets/images/youghmane.png"),
              width: width * 2,
              height: height,
            ),
            Container(
              width: width,
              height: height,
              color: sandyBeige,
            ),
            const Align(
              //top: height / 3,
              child: Text(
                "ايغمان",
                style: TextStyle(
                    fontFamily: 'Baloo2',
                    color: white,
                    fontSize: 85,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
                bottom: height * 0.03,
                right: width * 0.3,
                left: width * 0.3,
                child: const Text(
                  "Developed By LSIRA",
                  style: TextStyle(color: lightGrey),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const UserBottomNavBar(),
        ),
      ),
    );
  }
}

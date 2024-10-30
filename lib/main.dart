import 'package:flutter/material.dart';
import 'package:village_project/view/auth_screen/otp_screen.dart';
import 'package:village_project/view/user/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home:const SplashScreen(),
      home:OtpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


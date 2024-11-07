import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
import 'package:village_project/view/auth_screen/otp_screen.dart';

class AuthServices {
  static bool checkIfUserExist() {
    return true;
  }

  static bool checkIfPasswordCorrect() {
    return true;
  }

  static receiveOTP(
      {required String number, required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (verificationCompleted) {
            log("verfication Complete");
          },
          verificationFailed: (error) {
            log("verfication Failed ${error.toString()}");
          },
          codeSent: (verficationId, forceResendingToken) {
            Provider.of<OtpProviderController>(context, listen: false)
                .updateVerficationId(verficationId);
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => OtpScreen()));
          },
          codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) {});
    } catch (e) {
      log("error in receiveOTP : ${e.toString()}");
    }
  }


  static bool checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user == null ? false : true;
  }
}

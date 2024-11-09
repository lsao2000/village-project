import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
import 'package:village_project/view/auth_screen/SignInLogic.dart';
import 'package:village_project/view/auth_screen/otp_screen.dart';

class AuthServices {

  static receiveOTP(
      {required BuildContext context, required String mobileNumber}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        verificationCompleted: (phoneAuthCredential) {
          //log(phoneAuthCredential.toString());
          print("verification Completed :${phoneAuthCredential.toString()}");
        },
        verificationFailed: (error) {
          print("Error in verfication : ${error.toString()}");
          //log(error.toString());
        },
        codeSent: (verificationId, forceResendingToken) {
          context
              .read<OtpProviderController>()
              .updateVerficationId(verificationId);
              //.updateVerificationId(verficationId: verificationId);
          Navigator.push( context, PageTransition(
                  child: OtpScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      //log(e.toString());
      print("error in verify Phone Number ${e.toString()}");
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      print("Otp :$otp");
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: context.read<OtpProviderController>().verficationId,
          smsCode: otp);
      var creadential = await auth.signInWithCredential(authCredential);
      //creadential.user.uid;

      //Navigator.push(
      //   context,
      //    PageTransition(
      //        child: Signinlogic(),
      //        type: PageTransitionType.rightToLeft));
    } catch (e) {
      //log(e.toString());
      print("error in verify OTP: ${e.toString()}");
    }
  }
  static Future<String> checkIfphoneExist(
      String phone, String password, BuildContext ctx) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("JoinedUsers")
          .where('phoneNumber', isEqualTo: phone)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return 'not exist';
      }
      var user = querySnapshot.docs.first;
      bool validated = user['validated'];
      if (!validated) {
        return 'not validated';
      }
      String stordePassword = user['password'];
      if (stordePassword != password) {
        return 'incorrect password';
      }
      log("all done");
      receiveOTP(context: ctx, mobileNumber: phone);
      return 'done';
    } catch (e) {
      return e.toString();
    }
  }

  static bool checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user == null ? false : true;
  }
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/joined_user_provider.dart';
import 'package:village_project/controller/providers/auth_provider/otp_provider_controller.dart';
import 'package:village_project/controller/services/firebase_services/registration_services.dart';
import 'package:village_project/model/joined_user.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/view/auth_screen/SignInLogic.dart';
import 'package:village_project/view/auth_screen/otp_screen.dart';

class AuthServices {
  static receiveOTP({
    required BuildContext context,
    required String mobileNumber,
  }) async {
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
          Navigator.push(
              context,
              PageTransition(
                  child: const OtpScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      //log(e.toString());
      print("error in verify Phone Number ${e.toString()}");
    }
  }

  static verifyOTP({
    required BuildContext context,
    required String otp,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      print("Otp :$otp");
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: context.read<OtpProviderController>().verficationId,
          smsCode: otp);
      var creadential = await auth.signInWithCredential(authCredential);
      JoinedUser joinedUser =
          Provider.of<JoinedUserProvider>(context, listen: false).joinedUser;
      //log(joinedUser.getFirstName);
      IghoumaneUser ighoumaneUser = IghoumaneUser(
          firstName: joinedUser.getFirstName,
          lastName: joinedUser.getLastName,
          phoneNumber: joinedUser.getPhoneNumber,
          createAt: joinedUser.getCreatedDate,
          password: joinedUser.getPassword);
      //log(ighoumaneUser.getFirstName);
      ighoumaneUser.setUserId = creadential.user!.uid;
      Provider.of<IghoumaneUserProvider>(context, listen: false)
          .initilizeIghoumaneUser(ighoumaneUser);
      RegistrationServices.addNewUser(ighoumaneUser, creadential);
      Navigator.push(
          context,
          PageTransition(
              child: const Signinlogic(),
              type: PageTransitionType.rightToLeft));
    } catch (e) {
      //log(e.toString());
      print("error in verify OTP: ${e.toString()}");
    }
  }

  static Future<void> intilizeIghoumaneUser(BuildContext context) async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser!;
      String id = currentUser.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("user_id", isEqualTo: id)
          .get();
      var user = querySnapshot.docs.first;
      log("error here");
        Timestamp userTimeStamp = user['createdAt'];
        DateTime userDate = userTimeStamp.toDate();
      IghoumaneUser ighoumaneUser = IghoumaneUser(
          firstName: user['firstName'],
          lastName: user['lastName'],
          phoneNumber: user['phoneNumber'],
          createAt: userDate,
          password: user['password']);
      ighoumaneUser.setUserId = id;
      log(ighoumaneUser.toMap().toString());
      Provider.of<IghoumaneUserProvider>(context, listen: false) .initilizeIghoumaneUser(ighoumaneUser);
    } catch (e) {
      log("error in intializing  ${e.toString()}");
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
      //log("all done");
      String userId = user['user_id'];
      String firstName = user["firstName"];
      String lastName = user["lastName"];
      String passwordUser = user["password"];
      String phoneNumber = user["phoneNumber"];
      Timestamp createdAt = user["createdAt"];
      DateTime userDate = createdAt.toDate();
      JoinedUser joinedUser = JoinedUser(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          createAt: userDate,
          password: passwordUser);
      Provider.of<JoinedUserProvider>(ctx, listen: false)
          .intilizeJoinedUser(joinedUser, userId);
      //IghoumaneUser ighoumaneUser = IghoumaneUser(firstName: user['firstName'], lastName: lastName, phoneNumber: phoneNumber, createAt: createAt, password: password)
      receiveOTP(context: ctx, mobileNumber: phone);
      return 'done';
    } catch (e) {
      log("failed checking phone&password ${e.toString()}");
      return e.toString();
    }
  }

  static bool checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user == null ? false : true;
  }
}

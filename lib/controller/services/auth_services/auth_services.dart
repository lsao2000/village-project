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
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/ighoumane_user_post.dart';
import 'package:village_project/model/joined_user.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/model/user_ighoumane_freind.dart';
import 'package:village_project/view/auth_screen/SignInLogic.dart';
import 'package:village_project/view/auth_screen/otp_screen.dart';

class AuthServices {
  static receiveOTP(
      {required BuildContext context,
      required String mobileNumber,
      required bool isRegisterOtpType}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        verificationCompleted: (phoneAuthCredential) {
          log("verification Completed :${phoneAuthCredential.toString()}");
        },
        verificationFailed: (error) {
          log("Error in verfication : ${error.toString()}");
        },
        codeSent: (verificationId, forceResendingToken) {
          context
              .read<OtpProviderController>()
              .updateVerficationId(verificationId);
          context
              .read<OtpProviderController>()
              .updateOtpType(isRegisterOtpType);
          Navigator.push(
              context,
              PageTransition(
                  child: const OtpScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      log("error in verify Phone Number ${e.toString()}");
    }
  }

  static verifyOTP({
    required BuildContext context,
    required String otp,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      OtpProviderController otpProviderController =
          context.read<OtpProviderController>();
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: otpProviderController.verficationId, smsCode: otp);
      var creadential = await auth.signInWithCredential(authCredential);
      if (otpProviderController.isRegisterOtpType) {
        JoinedUser joinedUser =
            Provider.of<JoinedUserProvider>(context, listen: false).joinedUser;
        IghoumaneUser ighoumaneUser = IghoumaneUser(
            firstName: joinedUser.getFirstName,
            lastName: joinedUser.getLastName,
            phoneNumber: joinedUser.getPhoneNumber,
            createAt: joinedUser.getCreatedDate,
            password: joinedUser.getPassword,
            lstFreindsIds: []);
        ighoumaneUser.setUserId = creadential.user!.uid;
        Provider.of<IghoumaneUserProvider>(context, listen: false)
            .initilizeIghoumaneUser(ighoumaneUser);
        RegistrationServices.addNewUser(ighoumaneUser, creadential);
        Navigator.push(
            context,
            PageTransition(
                child: const Signinlogic(),
                type: PageTransitionType.rightToLeft));
      } else {
        Navigator.push(
            context,
            PageTransition(
                child: const Signinlogic(),
                type: PageTransitionType.rightToLeft));
      }
    } catch (e) {
      log(e.toString());
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
      Timestamp userTimeStamp = user['createdAt'];
      DateTime userDate = userTimeStamp.toDate();

      IghoumaneUser ighoumaneUser = IghoumaneUser(
          firstName: user['firstName'],
          lastName: user['lastName'],
          phoneNumber: user['phoneNumber'],
          createAt: userDate,
          password: user['password'],
          lstFreindsIds: user["freinds"] is Iterable
              ? List<String>.from(user["freinds"])
              : []);

      ighoumaneUser.setDescription = user['description'];
      ighoumaneUser.setUserId = id;
      var provider = Provider.of<IghoumaneUserProvider>(context, listen: false);
      provider.initilizeIghoumaneUser(ighoumaneUser);
      var querySnapshotPost = await FirebaseFirestore.instance
          .collection("posts")
          .orderBy("created_at", descending: true)
          .limit(5)
          .get();
      var queryCurrentUserPosts = await db
          .collection("posts")
          .where("user_id", isEqualTo: id)
          //.orderBy("created_at")
          .get();
      var lst = queryCurrentUserPosts.docs
          .map((el) => IghoumaneUserPost.getPostFromQuerySnapshot(el))
          .toList();
      lst.sort(
        (a, b) {
          return b.getCreatedAt.compareTo(a.getCreatedAt);
        },
      );

      provider.initilizeCurrentUserPosts(lst);
      await provider.initilizeListPost(querySnapshotPost.docs
          .map((el) => IghoumaneUserPost.getPostFromQuerySnapshot(el))
          .toList());
      _initilizeListFreindsUsers(
          lstFreindsIds: ighoumaneUser.getLstFreindsIds, context: context);
    } catch (e) {
      log("error in intializing  ${e.toString()}");
    }
  }

  static Future<bool> checkIfIghoumaneUserExist(
      {required String phoneNumber}) async {
    var user = await db
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();
    if (user.docs.isEmpty) {
      return false;
    }
    return true;
  }

  static Future<String> loginIghoumaneUser(
      {required QueryDocumentSnapshot<Map<String, dynamic>> user,
      required String phoneNum,
      required BuildContext context,
      required String password}) async {
    String stordePassword = user['password'];
    if (stordePassword != password) {
      return 'incorrect password';
    } else {
      receiveOTP(
          context: context, mobileNumber: phoneNum, isRegisterOtpType: false);
      return 'all done';
    }
  }

  static Future<String> checkIfphoneExist(
      String phone, String password, BuildContext ctx) async {
    try {
      var userExist = await checkIfIghoumaneUserExist(phoneNumber: phone);
      if (userExist) {
        log("ighoumaneUser exist");
        var user = await db
            .collection("users")
            .where("phoneNumber", isEqualTo: phone)
            .get();
        return loginIghoumaneUser(
            user: user.docs.first,
            phoneNum: phone,
            context: ctx,
            password: password);
        //return "ighoumane user exist";
      } else {
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
        receiveOTP(context: ctx, mobileNumber: phone, isRegisterOtpType: true);
        return 'done';
      }
    } catch (e) {
      log("failed checking phone&password ${e.toString()}");
      return e.toString();
    }
  }

  static _initilizeListFreindsUsers(
      {required List<String> lstFreindsIds,
      required BuildContext context}) async {
    try {
      if (lstFreindsIds.isNotEmpty) {
        int chunkSize = 10;
        List<UserIghoumaneFreind> newLstFreindIds = [];
        for (var i = 0; i < lstFreindsIds.length; i += chunkSize) {
          final freindIdsSublist = lstFreindsIds.sublist(
              i,
              i + chunkSize > lstFreindsIds.length
                  ? lstFreindsIds.length
                  : i + chunkSize);
          var data = await db
              .collection("users")
              .where("user_id", whereIn: freindIdsSublist)
              .get();
          newLstFreindIds.addAll(data.docs
              .map((el) => UserIghoumaneFreind.getFromDocumentSnapshot(el))
              .toList());
        }
        Provider.of<IghoumaneUserProvider>(context, listen: false)
            .initilizeListFreinds(newLstFreindIds);
        Provider.of<IghoumaneUserProvider>(context, listen: false)
            .updateIghoumaneUserLstFreindIds(lstFreindIds: lstFreindsIds);
      }
    } catch (e) {
      log("failed to initilizeListFreinds ${e.toString()}");
    }
  }

  static bool checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user == null ? false : true;
  }
}

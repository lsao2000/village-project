import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
class AuthServices {
  static bool checkIfUserExist(){
      return true;
  }

  static bool checkIfPasswordCorrect(){
      return true;
  }
  static receiveOTP({required String number, required BuildContext context }) async{
     FirebaseAuth auth = FirebaseAuth.instance;
     try {

         await auth.verifyPhoneNumber(
             verificationCompleted: (verificationCompleted){},
             verificationFailed: (verificationFailed){},
             codeSent: (verficationId, forceResendingToken){
                 //PhoneAuthCredential authCredential = PhoneAuthProvider.
             },
             codeAutoRetrievalTimeout:( codeAutoRetrievalTimeout){});
          } catch (e) {
              log("");
          }
  }

}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/services/auth_services/auth_services.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/auth_screen/auth_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<StatefulWidget> createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
    TextEditingController otpMsg = TextEditingController();
    @override
      void dispose() {
          otpMsg.dispose();
        super.dispose();
      }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Verfication",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: deepBlueDark),
          ),
          Usefulfunctions.blankSpace(width: width, height: height * 0.06),
          const Text(
            "Enter the SMS code",
            style: TextStyle(color: black, fontWeight: FontWeight.bold),
          ),
          Usefulfunctions.blankSpace(width: width, height: height * 0.02),
          Pinput(
              controller: otpMsg,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            defaultPinTheme: PinTheme(
              width: width * 0.1,
              height: height * 0.05,
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: Colors.black12, width: width * 0.01),
                ),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: width * 0.1,
              height: height * 0.05,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: deepBlueDark, width: width * 0.01),
                ),
              ),
            ),
            length: 6,
          ),
          Usefulfunctions.blankSpace(width: width, height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Didn't Receive sms code?  ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {},
                child:const Text(
                  "Resend",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Usefulfunctions.blankSpace(width: width, height: height * 0.1),
          CommonAuthButton(title: "Verfiy", onPressed: (){
              //AuthServices.verifyPhoneNumber();
              String otp = otpMsg.text.trim().toString();
              //log(otp);

              AuthServices.verifyOTP(context: context, otp: otp);
              log("end");
          },buttonWidth: width * 0.5,)
        ],
      ),
    );
  }
}

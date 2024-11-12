import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/services/auth_services/auth_services.dart';
import 'package:village_project/controller/services/firebase_services/registration_services.dart';
import 'package:village_project/model/joined_user.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/auth_screen/register_succes_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<StatefulWidget> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  bool inLogin = false;
  late bool _paswordVisible;
  late bool _registerPaswordVisible;
  late bool _verifyRegisterPaswordVisible;
  TextEditingController lastName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController registerPhone = TextEditingController();
  TextEditingController loginPhone = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController registerVerifyPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
    _paswordVisible = false;
    _registerPaswordVisible = false;
    _verifyRegisterPaswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text(
            "Ighoumane",
            style: TextStyle(
                color: deepBlueDark, fontFamily: "Baloo2", fontSize: 30),
          ),
        )),
        body: SingleChildScrollView(
          child: Center(
            child: Builder(builder: (ctx) {
              if (inLogin) {
                return loginScreen(width, height);
              }
              return registerScreen(width, height);
            }),
          ),
        ));
  }

  Widget registerScreen(double width, double height) {
    return Column(
      children: [
        Usefulfunctions.blankSpace(width: 0, height: height * 0.04),
        formField(width, height, firstName, "FirstName", TextInputType.text,
            FilteringTextInputFormatter.singleLineFormatter),
        formField(width, height, lastName, "LastName", TextInputType.text,
            FilteringTextInputFormatter.singleLineFormatter),
        formField(width, height, registerPhone, "Phone", TextInputType.phone,
            FilteringTextInputFormatter.digitsOnly),
        passwordFormField(width, height, registerPassword, "Password",
            _registerPaswordVisible, () {
          setState(() {
            _registerPaswordVisible = !_registerPaswordVisible;
          });
        }),
        passwordFormField(width, height, registerVerifyPassword,
            "Renter Password", _verifyRegisterPaswordVisible, () {
          setState(() {
            _verifyRegisterPaswordVisible = !_verifyRegisterPaswordVisible;
          });
        }),
        Usefulfunctions.blankSpace(width: 0, height: height * 0.04),
        // ***************Press Register button.
        CommonAuthButton(
          title: "Register",
          onPressed: () async {
            String fName = firstName.text.trim().toString();
            String lName = lastName.text.trim().toString();
            String phoneNum = registerPhone.text.trim().toString();
            String password = registerPassword.text.toString().trim();
            String passwordTwo = registerVerifyPassword.text.toString().trim();
            DateTime createdAccountDate = DateTime.now();
            JoinedUser joinedUser = JoinedUser(
                firstName: fName,
                lastName: lName,
                phoneNumber: "+$phoneNum",
                createAt: createdAccountDate,
                password: password);
            bool isAdded = await RegistrationServices.addUserInFirestore(
                joinedUser: joinedUser);
            isAdded
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => const RegisterSuccesScreen()),
                    (route) => false)
                : null;
          },
          buttonWidth: width,
        ),
        Usefulfunctions.blankSpace(width: 0, height: height * 0.01),
        Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          child: Row(
            children: [
              const Text(
                "Already have account? ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Usefulfunctions.blankSpace(width: width * 0.01, height: 0),
              InkWell(
                onTap: () {
                  setState(() {
                    inLogin = true;
                  });
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget loginScreen(double width, double height) {
    return Column(children: [
      Usefulfunctions.blankSpace(width: 0, height: height * 0.04),
      Container(
        margin: EdgeInsets.symmetric(
            vertical: height * 0.01, horizontal: width * 0.03),
        width: width,
        child: TextFormField(
          controller: loginPhone,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
              prefix:const Text("+212  "),
              prefixStyle:const TextStyle(color: black, fontSize: 16),
              hintText: "601010101",
              hintStyle:const TextStyle(color: Colors.black26),
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: const Text("Phone"),
            ),
            labelStyle: const TextStyle(
                color: Colors.black38, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.01),
                borderSide: const BorderSide(color: Colors.black38)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: deepBlueDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              //borderSide: const BorderSide(color: deepBlueDark),
              borderSide: const BorderSide(color: Colors.black38),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: Colors.black38),
            ),
          ),
          cursorColor: deepBlueDark,
        ),
      ),
      Usefulfunctions.blankSpace(width: 0, height: height * 0.02),
      Container(
        margin: EdgeInsets.symmetric(
            vertical: height * 0.01, horizontal: width * 0.03),
        width: width,
        child: TextFormField(
          controller: loginPassword,
          obscureText: _paswordVisible,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: const Text("Password"),
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _paswordVisible = !_paswordVisible;
                  });
                },
                icon: Icon(
                    _paswordVisible ? Icons.visibility_off : Icons.visibility)),
            labelStyle: const TextStyle(
                color: Colors.black38, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.01),
                borderSide: const BorderSide(color: Colors.black38)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: deepBlueDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              //borderSide: const BorderSide(color: deepBlueDark),
              borderSide: const BorderSide(color: Colors.black38),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: Colors.black38),
            ),
          ),
          cursorColor: deepBlueDark,
        ),
      ),
      Usefulfunctions.blankSpace(width: 0, height: height * 0.04),
      //*********** Press Login button.
      CommonAuthButton(
        title: "Login",
        onPressed: () async {
          String phone = loginPhone.text.trim().toLowerCase().toString();
          String password = loginPassword.text.trim().toLowerCase().toString();
          log("phone: +212$phone");
          log("password: $password");
          String checkExistence = await AuthServices.checkIfphoneExist( "+212$phone", password, context);
          log("answear $checkExistence");
        },
        buttonWidth: width,
      ),
      Usefulfunctions.blankSpace(width: 0, height: height * 0.02),
      Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.03),
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          children: [
            const Text(
              "Don't have account? ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Usefulfunctions.blankSpace(width: width * 0.01, height: 0),
            InkWell(
              onTap: () {
                setState(() {
                  inLogin = false;
                });
              },
              child: const Text(
                "Register",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget passwordFormField(
      double width,
      double height,
      TextEditingController controllerName,
      String lableValue,
      bool isVisible,
      VoidCallback onPressedCallback) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.03),
      width: width,
      child: TextFormField(
        controller: controllerName,
        obscureText: isVisible,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          label: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: Text(lableValue),
          ),
          suffixIcon: IconButton(
              onPressed: onPressedCallback,
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility)),
          labelStyle: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: Colors.black38)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: deepBlueDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            //borderSide: const BorderSide(color: deepBlueDark),
            borderSide: const BorderSide(color: Colors.black38),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: Colors.black38),
          ),
        ),
        cursorColor: deepBlueDark,
      ),
    );
  }

  Widget formField(
      double width,
      double height,
      TextEditingController controllerName,
      String lableValue,
      TextInputType inputType,
      TextInputFormatter inputFormater) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.03),
      width: width,
      child: TextFormField(
        controller: controllerName,
        keyboardType: inputType,
        inputFormatters: [inputFormater],
        decoration: InputDecoration(
          label: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: Text(lableValue),
          ),
          labelStyle: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: Colors.black38)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: deepBlueDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: Colors.black38),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: Colors.black38),
          ),
        ),
        cursorColor: deepBlueDark,
      ),
    );
  }
}

class CommonAuthButton extends StatelessWidget {
  const CommonAuthButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.buttonWidth});
  final String title;
  final VoidCallback onPressed;
  final double buttonWidth;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        width: buttonWidth,
        margin: EdgeInsets.symmetric(horizontal: width * 0.03),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(width * 0.02)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width, height * 0.06),
            backgroundColor: deepBlueDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: onPressed,
          child: Text(title,
              style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: "Baloo2")
              //style: textTheme.displaySmall,
              ),
        ));
  }
}

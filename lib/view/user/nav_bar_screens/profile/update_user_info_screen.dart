import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/auth_services/auth_services.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/auth_screen/auth_screen.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({super.key});
  @override
  State<StatefulWidget> createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late IghoumaneUserProvider ighoumaneUserProvider;
  @override
  void initState() {
    ighoumaneUserProvider = Provider.of<IghoumaneUserProvider>(context, listen: false);
    firstName.text = ighoumaneUserProvider.ighoumaneUser.getFirstName;
    lastName.text = ighoumaneUserProvider.ighoumaneUser.getLastName;
    description.text = ighoumaneUserProvider.ighoumaneUser.getDescription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.2),
                    child: Image(
                      fit: BoxFit.fill,
                      image: const AssetImage("assets/images/youghmane.png"),
                      width: width * 0.21,
                      height: height * 0.1,
                    ),
                  ),
                ),
                Usefulfunctions.blankSpace(width: 0, height: height * 0.03),
                //const Text(
                //  "First Name",
                //  style: TextStyle(
                //    fontWeight: FontWeight.bold,
                //  ),
                //),
                formField(
                    width,
                    height,
                    firstName,
                    "firstName",
                    TextInputType.text,
                    FilteringTextInputFormatter.singleLineFormatter, (value) {
                  if (value == null || value.isEmpty) {
                    return "please fill the box";
                  }
                  return null;
                }),
                //const Text(
                //  "Last Name",
                //  style: TextStyle(
                //    fontWeight: FontWeight.bold,
                //  ),
                //),
                formField(
                    width,
                    height,
                    lastName,
                    "lastName",
                    TextInputType.text,
                    FilteringTextInputFormatter.singleLineFormatter, (value) {
                  if (value == null || value.isEmpty) {
                    return "please fill the box";
                  }
                  return null;
                }),
                //const Text(
                //  "Description",
                //  style: TextStyle(
                //    fontWeight: FontWeight.bold,
                //  ),
                //),
                formField(
                    width,
                    height,
                    description,
                    "Description",
                    TextInputType.text,
                    FilteringTextInputFormatter.singleLineFormatter, (value) {
                  return null;
                }),
                Usefulfunctions.blankSpace(width: 0, height: height * 0.03),
                // -------- button to save data
                Center(
                  child: CommonAuthButton(
                      title: "save",
                      onPressed: () {
                        String fNameValue = firstName.text.trim().toString();
                        String lNameValue = lastName.text.trim().toString();
                        String descriptionValue =
                            description.text.trim().toString();
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            IghoumaneUser updateIghoumaneUser = IghoumaneUser(
                                firstName: fNameValue,
                                lastName: lNameValue,
                                phoneNumber: ighoumaneUserProvider.ighoumaneUser.getPhoneNumber,
                                createAt: ighoumaneUserProvider.ighoumaneUser.getCreatedDate,
                                password: ighoumaneUserProvider.ighoumaneUser.getPassword);
                            updateIghoumaneUser.setDescription = descriptionValue;
                            updateIghoumaneUser.setUserId =
                                ighoumaneUserProvider.ighoumaneUser.getUserId;
                           ighoumaneUserProvider.updateIghoumaneUser(updateIghoumaneUser);
                            UserServices.updateUserInfo(
                                context: context,
                                ighoumaneUser: updateIghoumaneUser);
                          } catch (e) {
                            print("error in update user ${e.toString()}");
                          }
                        }
                      },
                      buttonWidth: width * 0.4),
                ),
                Usefulfunctions.blankSpace(width: 0, height: height * 0.03),
                Center(
                    child: TextButton.icon(
                  onPressed: () {
                    log("delete");
                  },
                  label: const Text(
                    "account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19, color: red),
                  ),
                  icon: Icon(
                    Icons.delete,
                    color: red,
                    size: width * 0.1,
                  ),
                ))
              ],
            )),
      )),
    );
  }

  Widget formField(
      double width,
      double height,
      TextEditingController controllerName,
      String lableValue,
      TextInputType inputType,
      TextInputFormatter inputFormater,
      FormFieldValidator<String> func) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      width: width,
      child: TextFormField(
        controller: controllerName,
        keyboardType: inputType,
        inputFormatters: [inputFormater],
        validator: func,
        //validator: (value) {
        //  if (value == null || value.isEmpty) {
        //    return "Please fill the box";
        //  }
        //},
        decoration: InputDecoration(
          //error: Text("empty"),
          //errorText: "empty",
          label: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01),
            child: Text(lableValue),
          ),
          labelStyle:
              const TextStyle(color: black38, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.01),
              borderSide: const BorderSide(color: black38)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: deepBlueDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: black38),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.01),
            borderSide: const BorderSide(color: black38),
          ),
        ),
        cursorColor: deepBlueDark,
      ),
    );
  }
}

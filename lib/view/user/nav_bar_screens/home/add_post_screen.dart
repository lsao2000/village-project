import 'package:flutter/material.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/services/firebase_services/post_services/users_post_services.dart';
import 'package:village_project/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});
  @override
  State<StatefulWidget> createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  TextEditingController content = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: const Text(
            "Ighoumane",
            style: TextStyle(
                color: deepBlueDark, fontFamily: "Baloo2", fontSize: 30),
          ),
        ),
        body: Form(
          key: _fromKey,
          child: Column(
            children: [
              Usefulfunctions.blankSpace(width: 0, height: height * 0.04),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.03),
                color: white,
                width: width,
                child: TextFormField(
                  controller: content,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Type your post";
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Type...",
                    hintStyle: const TextStyle(color: black38),
                    labelStyle: const TextStyle(
                        color: black38, fontWeight: FontWeight.bold),
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
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.024),
                            decoration: BoxDecoration(
                                color: lightGrey,
                                borderRadius:
                                    BorderRadius.circular(width * 0.2)),
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                color: deepBlueDark,
                                Icons.emoji_emotions_outlined,
                              ),
                            ),
                          ),
                          Usefulfunctions.blankSpace(
                              width: width * 0.03, height: 0),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.024),
                            decoration: BoxDecoration(
                                color: lightGrey,
                                borderRadius:
                                    BorderRadius.circular(width * 0.2)),
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                color: deepBlueDark,
                                Icons.image_outlined,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: deepBlueDark),
                        onPressed: () {
                          if (_fromKey.currentState?.validate() ?? false) {
                            String contentValue =
                                content.text.trim().toString();
                            UsersPostServices.addPost(
                                content: contentValue, context: context);
                          }
                        },
                        child: const Text(
                          "add post",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

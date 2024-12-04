import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/utils/colors.dart';

class DiscussionsScreen extends StatefulWidget {
  const DiscussionsScreen({super.key});
  @override
  State<StatefulWidget> createState() => DiscussionsScreenState();
}

class DiscussionsScreenState extends State<DiscussionsScreen> {
  TextEditingController messageController = TextEditingController();
  List<String> lstMessages = [
    "lsid slisid lsdif ",
    "klsdi lsdi isj dksilisdi lk",
    "lksdisk ljsi ",
    "lisid jsd is ",
    "jks is ks lis ksie slsi lsi s ilsldlisi lis ds jlksjdil sjksdfi kjsk fdi ",
    "lkjsd iks jisie ",
    "lksd qie kj3i2po2 3kjsij s",
    "k sdi slkdj osej ji",
    "lksd",
    "lksdfks lkjsd is",
    "lksjd k3ikjs o si3",
    "lksd ik lso elj ",
    "/skj flkjsd iksd isdk sji "
        "lksdisk ljsi ",
    "lisid jsd is ",
    "jks is ks lis ksie slsi lsi s ilsldlisi lis ds jlksjdil sjksdfi kjsk fdi ",
    "k sdi slkdj osej ji",
    "lksd",
    "lksdfks lkjsd is",
    "lksjd k3ikjs o si3",
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(children: [
      showMessages(width, height),
      showOnlineToggle(width, height),
      sendMessageWidget(width, height),
    ]);
  }

  Widget showMessages(double width, double height) {
    return SizedBox(
      width: width,
      child: ListView.builder(
        itemCount: lstMessages.length,
        itemBuilder: (ctx, index) {
          String textValue = lstMessages[index];
          double widthT = calculateTextWidth(textValue, width);
          if (index == 6) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.004, horizontal: width * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.005, horizontal: width * 0.03),
                    constraints: BoxConstraints(maxWidth: width * 0.8),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                log("tapped");
                              },
                              child: const Text("you"),
                            ),
                            Usefulfunctions.blankSpace(
                                width: widthT * 0.65, height: 0),
                            const Text(
                              "11-11-2013",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            )
                          ],
                        ),
                        Text(
                          textValue,
                          style: const TextStyle(
                              color: black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.004, horizontal: width * 0.02),
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.005, horizontal: width * 0.03),
                constraints: BoxConstraints(maxWidth: width * 0.8),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            log("tapped");
                          },
                          child: const Text("flan"),
                        ),
                        Usefulfunctions.blankSpace(
                            width: widthT * 0.65, height: 0),
                        const Text(
                          "11-11-2013",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )
                      ],
                    ),
                    Text(
                      textValue,
                      style: const TextStyle(
                          color: black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget showOnlineToggle(double width, double height) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        padding: EdgeInsets.symmetric(
            vertical: height * 0.005, horizontal: width * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.1),
            color: Colors.black12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              color: Colors.green,
              size: width * 0.04,
            ),
            Usefulfunctions.blankSpace(width: width * 0.02, height: 0),
            const Text(
              "1329",
              style: TextStyle(color: black),
            ),
            Usefulfunctions.blankSpace(width: width * 0.01, height: 0),
          ],
        ),
      ),
    );
  }

  Widget sendMessageWidget(double width, double height) {
    return Positioned(
      bottom: height * 0.01,
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height * 0.06,
              margin: EdgeInsets.symmetric(horizontal: width * 0.02),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(width * 0.1)),
              child: TextFormField(
                controller: messageController,
                cursorColor: deepBlue,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Type...",
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.1),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.1),
                      borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.1),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.1),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Usefulfunctions.blankSpace(width: width * 0.02, height: 0),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.send,
              color: deepBlueDark,
              size: width * 0.08,
            ),
          ),
          Usefulfunctions.blankSpace(width: width * 0.02, height: 0),
        ],
      ),
    );
  }

  double calculateTextWidth(String text, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      //maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: width * 0.05, maxWidth: width * 0.8);
    return textPainter.size.width;
  }
}

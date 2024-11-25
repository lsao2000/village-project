import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/chat_services/chat_services.dart';
import 'package:village_project/controller/services/firebase_services/post_services/users_post_services.dart';
import 'package:village_project/model/message_model.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';

class MessagingScreen extends StatefulWidget {
  MessagingScreen({super.key, required this.freindId});
  String freindId;
  @override
  State<StatefulWidget> createState() => MessagingScreenState();
}

class MessagingScreenState extends State<MessagingScreen> {
  TextEditingController msgController = TextEditingController();
  late IghoumaneUserProvider ighoumaneUserProvider;
  late List<MessageModel> lstMessages;
  @override
  void initState() {
    setState(() {
      ighoumaneUserProvider = context.read<IghoumaneUserProvider>();
      lstMessages = [
        MessageModel(
            messageId: "lslss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "chtari wldna",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsislss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "mnin biha ya khayi",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsleoelss",
            senderId: "lsd",
            text: "rani fog izili",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lshghlss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text:
                "winta tla3t, mhm goli wa7d lbomba kant 3andek mzal f dar wal lawah 3ndi wa7d rwida mafchocha",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsss",
            senderId: "lskdfi",
            text: "tla3t lyom m3a sab7 bkri",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lslss",
            senderId: "lskdfi",
            text: "bghit njba 3la dar",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lslss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "chtari wldna",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsislss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "mnin biha ya khayi",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsleoelss",
            senderId: "lsd",
            text: "rani fog izili",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lslss",
            senderId: "lsds",
            text: "mhm ila ghda yak lahi ngad",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lslss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "safi rana ntrayaw inchallah",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lslss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "chtari wldna",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsislss",
            senderId: ighoumaneUserProvider.ighoumaneUser.getUserId,
            text: "mnin biha ya khayi",
            sendingTime: DateTime.now()),
        MessageModel(
            messageId: "lsleoelss",
            senderId: "lsd",
            text: "rani fog izili",
            sendingTime: DateTime.now()),
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: ChatServices.getPosterInfo(userId: widget.freindId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(
              color: deepBlue,
            ),
          ));
        }

        IghoumaneUser ighoumaneFreind = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            title: Container(
              margin: EdgeInsets.symmetric(vertical: height * 0.04),
              //padding: EdgeInsets.symmetric(vertical: height * 0.01),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.1),
                    child: Image(
                      fit: BoxFit.cover,
                      width: width * 0.105,
                      height: height * 0.05,
                      image: const AssetImage("assets/images/youghmane.png"),
                    ),
                  ),
                  Usefulfunctions.blankSpace(width: width * 0.02, height: 0),
                  Text(
                    "${ighoumaneFreind.getFirstName} ${ighoumaneFreind.getLastName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              showMessages(
                  width, height, ighoumaneUserProvider.ighoumaneUser.getUserId),
              //Usefulfunctions.blankSpace(width: 0, height:height* 0.01),
              messagingBox(width: width, height: height),
            ],
          ),
        );
      },
    );
  }

  Widget messagingBox({required double width, required double height}) {
    return Positioned(
      bottom: 0,
      width: width,
      child: Container(
        decoration: const BoxDecoration(color: white),
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        //padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.01),
        //margin: EdgeInsets.only(top: height * 0.01,bottom: height * 0.01),
        child: Row(
          children: [
            Expanded(
              child: Container(
                //height: height * 0.06,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(width * 0.01),
                ),
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: TextFormField(
                  controller: msgController,
                  cursorColor: deepBlue,
                  onChanged: (value) {
                    setState(() {
                      msgController.text = value;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Type...",
                    hintStyle: const TextStyle(color: black38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.01),
                      borderSide: const BorderSide(color: grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.01),
                        borderSide: const BorderSide(color: deepBlue)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.01),
                      borderSide: const BorderSide(color: grey),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.01),
                      borderSide: const BorderSide(color: grey),
                    ),
                  ),
                ),
              ),
            ),
            Usefulfunctions.blankSpace(width: width * 0.02, height: 0),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.023),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.5),
                color: deepBlueDark,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  msgController.text.toString().isEmpty
                      ? Icons.mic
                      : Icons.send,
                  key: ValueKey<bool>(msgController.text.toString().isEmpty),
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showMessages(double width, double height, String currentUserId) {
    return Container(
      //padding: EdgeInsets.only(bottom: height * 0.1),
      margin: EdgeInsets.only(bottom: height * 0.088),
      //width: width,
      //height:height * 0.9 ,
      child: ListView.builder(
        itemCount: lstMessages.length,
        itemBuilder: (ctx, index) {
          MessageModel messageModel = lstMessages[index];
          double widthT = calculateTextWidth(messageModel.getTextMsg, width);
          if (currentUserId == messageModel.getSenderId) {
            return Align(
              alignment: Alignment.topRight,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.004, horizontal: width * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.005, horizontal: width * 0.03),
                    constraints: BoxConstraints(
                        maxWidth: width * 0.8), // Limit max width
                    decoration: BoxDecoration(
                        color: deepBlueDark,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize:
                          MainAxisSize.min, // Minimize the size to fit content
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                              right: width * 0.05,
                            ),
                            child: Text(
                              messageModel.getTextMsg,
                              style: const TextStyle(
                                  color: white, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                            height: height * 0.005), // Space before timestamp
                        Text(
                          "${messageModel.getSendingTime.hour}:${messageModel.getSendingTime.minute}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.004, horizontal: width * 0.02),
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.005, horizontal: width * 0.01),
                constraints: BoxConstraints(maxWidth: width * 0.8),
                decoration: BoxDecoration(
                    color: lightGrey, borderRadius: BorderRadius.circular(6)),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize:
                      MainAxisSize.min, // Minimize the size to fit content
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          right: width * 0.05,
                        ),
                        child: Text(
                          messageModel.getTextMsg,
                          style: const TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: height * 0.005), // Space before timestamp
                    Text(
                      "${messageModel.getSendingTime.hour}:${messageModel.getSendingTime.minute}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: black,
                      ),
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

  double calculateTextWidth(String text, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      //maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: width * 0.05, maxWidth: width * 0.8);
    return textPainter.size.width;
  }
}

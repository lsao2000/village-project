import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/chat_services/chat_services.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/message_model.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/utils/colors.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key, required this.freindId});
  final String freindId;
  @override
  State<StatefulWidget> createState() => MessagingScreenState();
}

class MessagingScreenState extends State<MessagingScreen> {
  TextEditingController msgController = TextEditingController();
  late IghoumaneUserProvider ighoumaneUserProvider;
  late List<MessageModel> lstMessages;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    setState(() {
      ighoumaneUserProvider = context.read<IghoumaneUserProvider>();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: ChatServices.getFreindInfo(userId: widget.freindId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: deepBlue,
              ),
            ),
          );
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
                  InkWell(
                    onTap: () {
                      //ChatServices.getFreindShipType(
                      //    freindId: widget.freindId, context: context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.1),
                      child: Image(
                        fit: BoxFit.cover,
                        width: width * 0.105,
                        height: height * 0.05,
                        image: const AssetImage("assets/images/youghmane.png"),
                      ),
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
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              _handleExitPage();
            },
            child: FutureBuilder(
              future: ChatServices.getFreindShipType(
                  freindId: widget.freindId, context: context),
              builder: (ctx, snapshot) {
                var data = snapshot.data;
                //if (snapshot.connectionState == ConnectionState.waiting) {
                //  return const Center(
                //    child: CircularProgressIndicator(
                //      color: deepBlue,
                //    ),
                //  );
                //}
                //else {
                //if (data?.getStatus == "requested") {
                //  return const Center(
                //    child: Text(
                //      "The user has not accepted your following request yet",
                //      style: TextStyle(fontWeight: FontWeight.bold,  color: black38),
                //    ),
                //  );
                //} else {
                return Stack(
                  children: [
                    showMessages(width, height,
                        ighoumaneUserProvider.ighoumaneUser.getUserId),
                    messagingBox(width: width, height: height),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleExitPage() async {
    //print("exit screen");
    await UserServices.updateChatingWithStatus(
        currentUserId: ighoumaneUserProvider.ighoumaneUser.getUserId,chatingWith: null);
    Navigator.pop(context);
  }

  Widget messagingBox({required double width, required double height}) {
    return Form(
      key: _formKey,
      child: Positioned(
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
                    validator: (value) {
                      if ((value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) &&
                          msgController.text.toString().isEmpty) {
                        return "Please Type your post";
                      }
                      return null;
                    },
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
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: msgController.text.toString().isEmpty
                      ? InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.mic,
                            key: ValueKey<bool>(
                                msgController.text.toString().isEmpty),
                            color: white,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              ChatServices.checkIfChatExist(
                                  freindId: widget.freindId,
                                  context: context,
                                  msgContent: removeExtraSpaces(
                                      msgController.text.trim()));
                              msgController.text = "";
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showMessages(double width, double height, String currentUserId) {
    return StreamBuilder(
        stream: ChatServices.getMessagesFreind(
            currentUserId: currentUserId, freindId: widget.freindId),
        builder: (ctx, streamData) {
          if (streamData.connectionState == ConnectionState.waiting &&
                  !streamData.hasData ||
              streamData.data!.docs.isEmpty) {
            log("here");
            return const Center(
              child: CircularProgressIndicator(
                color: deepBlue,
              ),
            );
          }
          //} else if (!streamData.hasData || streamData.data!.docs.isEmpty) {
          //  log("no here");
          //  return Container(
          //    width: width ,
          //    height: height,
          //    child: const Center(
          //      child: Text("no data"),
          //    ),
          //  );
          //}
          List<MessageModel> lstMessagesData = streamData.data!.docs.map((el) {
            Timestamp dateStamp = el["sendingTime"];
            return MessageModel.fromQuerySnapshot(
                messageId: el.id,
                senderId: el["senderId"],
                text: el["msgText"],
                sendingTime: dateStamp.toDate());
          }).toList();
          return Container(
            margin: EdgeInsets.only(bottom: height * 0.088),
            child: ListView.builder(
                itemCount: lstMessagesData.length,
                itemBuilder: (ctx, index) {
                  MessageModel messageModel = lstMessagesData[index];
                  //double widthT = calculateTextWidth(messageModel.getTextMsg, width);
                  // check if index is 0 and display the date
                  if (index == 0) {
                    DateTime currentDate = DateTime.now();
                    // chek if message date day is the same day
                    if (messageModel.getSendingTime.day
                            .compareTo(currentDate.day) ==
                        0) {
                      // chek  if the message is from the current use
                      if (currentUserId == messageModel.getSenderId) {
                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.001),
                                  decoration: BoxDecoration(
                                      color: lightGrey,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.1)),
                                  child: const Text(
                                    "Today",
                                    style: TextStyle(
                                        color: black38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            messageView(
                                width: width,
                                height: height,
                                messageModel: messageModel,
                                currentUserId: true)
                          ],
                        );
                      }
                      // the message is not from the current use
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.001),
                                decoration: BoxDecoration(
                                    color: lightGrey,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.1)),
                                child: const Text(
                                  "Today",
                                  style: TextStyle(
                                      color: black38,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          messageView(
                              width: width,
                              height: height,
                              messageModel: messageModel,
                              currentUserId: false)
                        ],
                      );
                    }
                    // if meesage date day is not the same day
                    else {
                      // chek if the message is from the current user
                      if (currentUserId == messageModel.getSenderId) {
                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.001),
                                  decoration: BoxDecoration(
                                      color: lightGrey,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.1)),
                                  child: Text(
                                    Usefulfunctions.getDateFormat(
                                        dateFormated: lstMessagesData[index + 1]
                                            .getSendingTime,
                                        context: context),
                                    style: const TextStyle(
                                        color: black38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            messageView(
                                width: width,
                                height: height,
                                messageModel: messageModel,
                                currentUserId: true)
                          ],
                        );
                      }
                      //  if the message is not from the current user
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.001),
                                decoration: BoxDecoration(
                                    color: lightGrey,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.1)),
                                child: Text(
                                  Usefulfunctions.getDateFormat(
                                      dateFormated: lstMessagesData[index + 1]
                                          .getSendingTime,
                                      context: context),
                                  style: const TextStyle(
                                      color: black38,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          messageView(
                              width: width,
                              height: height,
                              messageModel: messageModel,
                              currentUserId: false)
                        ],
                      );
                    }
                  }
                  // if the index is not equal to 0
                  else {
                    DateTime currentDate = DateTime.now();
                    // chek if the message date is the same as next message date
                    if (index - 1 >= 0 &&
                        lstMessagesData[index].getSendingTime.day ==
                            lstMessagesData[index - 1].getSendingTime.day) {
                      // chek  if the message is from the current use
                      if (currentUserId == messageModel.getSenderId) {
                        return Column(
                          children: [
                            messageView(
                                width: width,
                                height: height,
                                messageModel: messageModel,
                                currentUserId: true)
                          ],
                        );
                      }
                      // the message is not from the current use
                      return Column(
                        children: [
                          messageView(
                              width: width,
                              height: height,
                              messageModel: messageModel,
                              currentUserId: false)
                        ],
                      );
                    }
                    // chek if the message date is not the same as message date before
                    else {
                      // chek if the message is from the current user
                      if (currentUserId == messageModel.getSenderId) {
                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.001),
                                  decoration: BoxDecoration(
                                      color: lightGrey,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.1)),
                                  child: Text(
                                    compareDateMessageWithCurrentDay(
                                            messageDate: lstMessagesData[index]
                                                .getSendingTime)
                                        ? "Today"
                                        : Usefulfunctions.getDateFormat(
                                            dateFormated: lstMessagesData[index]
                                                .getSendingTime,
                                            context: context),
                                    style: const TextStyle(
                                        color: black38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            messageView(
                                width: width,
                                height: height,
                                messageModel: messageModel,
                                currentUserId: true)
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.001),
                                decoration: BoxDecoration(
                                    color: lightGrey,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.1)),
                                child: Text(
                                  compareDateMessageWithCurrentDay(
                                          messageDate: lstMessagesData[index]
                                              .getSendingTime)
                                      ? "Today"
                                      : Usefulfunctions.getDateFormat(
                                          dateFormated: lstMessagesData[index]
                                              .getSendingTime,
                                          context: context),
                                  style: const TextStyle(
                                      color: black38,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          messageView(
                              width: width,
                              height: height,
                              messageModel: messageModel,
                              currentUserId: false)
                        ],
                      );
                    }
                  }
                }),
          );
        });
  }

  Widget messageView(
      {required double width,
      required double height,
      required MessageModel messageModel,
      required bool currentUserId}) {
    return Align(
      alignment: currentUserId ? Alignment.topRight : Alignment.topLeft,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: height * 0.004, horizontal: width * 0.02),
            padding: EdgeInsets.only(
                top: height * 0.005,
                bottom: height * 0.005,
                left: width * 0.02,
                right: width * 0.03),
            constraints: BoxConstraints(maxWidth: width * 0.8),
            decoration: BoxDecoration(
                color: currentUserId ? deepBlueDark : lightGrey,
                borderRadius: BorderRadius.circular(6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize:
                  MainAxisSize.min, // Minimize the size to fit content
              children: [
                Container(
                    margin: EdgeInsets.only(
                      right: width * 0.04,
                    ),
                    child: Text(
                      messageModel.getTextMsg,
                      style: TextStyle(
                          color: currentUserId ? white : black,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: height * 0.005), // Space before timestamp
                Text(
                  Usefulfunctions.getHourMinuteFormat(
                      formatingDate: messageModel.getSendingTime),
                  //"${messageModel.getSendingTime.hour}:${messageModel.getSendingTime.minute}",
                  style: TextStyle(
                    fontSize: 10,
                    color: currentUserId ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateTextWidth(String text, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: width * 0.05, maxWidth: width * 0.8);
    return textPainter.size.width;
  }

  String removeExtraSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool compareDateMessageWithCurrentDay({required DateTime messageDate}) {
    DateTime currentDay = DateTime.now();
    return messageDate.day == currentDay.day &&
        messageDate.year == currentDay.year &&
        messageDate.month == currentDay.month;
  }
}

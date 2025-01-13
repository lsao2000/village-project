import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/firebase_services/chat_services/chat_services.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/user.dart';
import 'package:village_project/model/user_ighoumane_freind.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/nav_bar_screens/chat/messaging_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late IghoumaneUser currentUser;
  @override
  void initState() {
    setState(() {
      currentUser = Provider.of<IghoumaneUserProvider>(context, listen: false)
          .ighoumaneUser;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<UserIghoumaneFreind> lstAllFreindUser =
        Provider.of<IghoumaneUserProvider>(context).lstFreinds;
    return ListView.builder(
        itemCount: lstAllFreindUser.length,
        itemBuilder: (ctx, index) {
          UserIghoumaneFreind userIghoumaneFreind = lstAllFreindUser[index];
          return InkWell(
              onTap: () {
                UserServices.updateChatingWithStatus(
                    currentUserId: currentUser.getUserId,
                    chatingWith: userIghoumaneFreind.getId);
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => MessagingScreen(
                      freindId: userIghoumaneFreind.getId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: height * .01, horizontal: width * 0.03),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: deepBlue))),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.1),
                      child: Image(
                        fit: BoxFit.cover,
                        width: width * 0.15,
                        height: height * 0.07,
                        image: const AssetImage("assets/images/youghmane.png"),
                      ),
                    ),
                    Usefulfunctions.blankSpace(
                        width: width * 0.04, height: height * 0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // freind name.
                              Text(
                                "${userIghoumaneFreind.getFirstName} ${userIghoumaneFreind.getastName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              // notifcation message number.
                              //Builder(builder: (ctx) {
                              //  if (freindModel.getNotificationMessageCount ==
                              //      0) {
                              //    return const Text("");
                              //  }
                              //  return Container(
                              //    width: width * 0.05,
                              //    height: height * 0.05,
                              //    alignment: Alignment.center,
                              //    decoration: const BoxDecoration(
                              //      color: deepBlueDark,
                              //      shape: BoxShape.circle,
                              //    ),
                              //    child: Text(
                              //      "${freindModel.getNotificationMessageCount}",
                              //      style: TextStyle(
                              //        color: white,
                              //        fontWeight: FontWeight.bold,
                              //        fontSize: width * 0.03,
                              //      ),
                              //    ),
                              //  );
                              //}),
                            ],
                          ),
                        ),
                        StreamBuilder(
                            stream: ChatServices.getLastMessagesFreind(
                                currentUserId: currentUser.getUserId,
                                freindId: userIghoumaneFreind.getId),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  "Loading",
                                  style: TextStyle(
                                      color: lightGrey,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              var data = snapshot.data!.docs.first;
                              return Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.7),
                                child: Text(
                                  data["msgText"].toString(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}

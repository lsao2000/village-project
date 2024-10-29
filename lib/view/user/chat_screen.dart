import 'package:flutter/material.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/model/freind_model.dart';
import 'package:village_project/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<FreindModel> lstAllFreindModel = [
    FreindModel(
        name: "Hasan Fdayli",
        message: "Chtari 3andek ya jit 3andek gbil ma jbartk",
        notifcationMessageCount: 2),
    FreindModel(
        name: "Mohamed Fdayli", message: "slm", notifcationMessageCount: 1),
    FreindModel(
        name: "Ali Fdayli",
        message: "jib m3ak atay",
        notifcationMessageCount: 0),
    FreindModel(
        name: "Makhtar Ben3mer",
        message: "Chtari ya",
        notifcationMessageCount: 4),
    FreindModel(
        name: "Yossef Bouchan",
        message: "la tnsa maya",
        notifcationMessageCount: 3),
    FreindModel(
        name: "Hasan Skaih",
        message: "lah ykch7ak",
        notifcationMessageCount: 0),
    FreindModel(
        name: "Bayhi Tanbih",
        message: "Chtari 3andek ya",
        notifcationMessageCount: 1),
    FreindModel(
        name: "Smail Skaih", message: "ma bhit", notifcationMessageCount: 5),
    FreindModel(
        name: "Hasan Fdayli",
        message: "ma jbarto ya khayi",
        notifcationMessageCount: 0),
    FreindModel(
        name: "Faryat Bouchan",
        message: "inchallah",
        notifcationMessageCount: 11),
    FreindModel(
        name: "Abdellah Fdayli",
        message: "amin ya molana",
        notifcationMessageCount: 1),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: lstAllFreindModel.length,
        itemBuilder: (ctx, index) {
          FreindModel freindModel = lstAllFreindModel[index];
          return InkWell(
              onTap: () {},
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
                        Container(
                          width: width * 0.7,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // freind name.
                              Text(
                                freindModel.getName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              // notifcation message number.
                              Builder(builder: (ctx) {
                                if (freindModel.getNotificationMessageCount ==
                                    0) {
                                  return const Text("");
                                }
                                return Container(
                                  width: width * 0.05,
                                  height: height * 0.05,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: deepBlueDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${freindModel.getNotificationMessageCount}",
                                    style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.03,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: width * 0.7),
                          child: Text(
                            freindModel.getMessage,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}

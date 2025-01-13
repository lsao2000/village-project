import 'package:flutter/material.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/nav_bar_screens/meeting/meeting_page.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});
  @override
  State<StatefulWidget> createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (ctx, index) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.03),
          margin: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.005),
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: deepBlue)),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "things of aouina people",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Usefulfunctions.blankSpace(width: 0, height: height * 0.005),
              SizedBox(
                width: width,
                height: height * 0.024,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (ctx, index) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.1),
                          child: Image(
                            fit: BoxFit.cover,
                            width: width * 0.05,
                            height: height * 0.02,
                            image:
                                const AssetImage("assets/images/youghmane.png"),
                          ),
                        ),
                        Usefulfunctions.blankSpace(
                            width: width * 0.01, height: 0),
                      ],
                    );
                  },
                ),
              ),
              Usefulfunctions.blankSpace(width: 0, height: height * 0.005),
              Center(
                child: Container(
                  height: height * 0.045,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.2),
                      color: deepBlueDark),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (ctx) => const MeetingPage()));
                    },
                    child: const Text(
                      "join",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

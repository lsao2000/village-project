import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
    late String id;
    @override
      void initState() {
        super.initState();
        getUid();
      }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * .03),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.2),
                        child: Image(
                          fit: BoxFit.fill,
                          image:
                              const AssetImage("assets/images/youghmane.png"),
                          width: width * 0.2,
                          height: height * 0.1,
                        ),
                      ),
                      const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.settings,
                            color: deepBlueDark,
                          )),
                    ],
                  ),
                  Usefulfunctions.blankSpace(width: width * 0.3, height: 0),
                  RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          style: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: "24\n"),
                            TextSpan(text: "Posts"),
                          ])),
                  Usefulfunctions.blankSpace(width: width * 0.1, height: 0),
                  RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          style: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: "7\n"),
                            TextSpan(text: "Freinds"),
                          ])),
                ],
              ),
              Usefulfunctions.blankSpace(height: height * 0.01, width: 0),
               Text(
                maxLines: 1,
                id,
                style:const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "10-11-2024 ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        //fontFamily: "Baloo2",
                        //color: black
                        color: Colors.black26,
                        //fontSize: 11
                      ),
                    ),
                  ],
                ),
              ),
              Usefulfunctions.blankSpace(height: height * 0.01, width: 0),
              SizedBox(
                width: width * 0.7,
                child: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.parent,
                  //maxLines: ,
                  text: const TextSpan(children: [
                    TextSpan(
                        text:
                            "lis lsids lsdi lkjsdij ksdi jlsjid sl islisi lsids ils is lsid sk ski aj ijsd ksajij kjsadoiflajsi jsi aij osk jsoij lsj oijlksjdlj ijlj a",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis, color: black))
                  ]),
                ),
              ),
              Usefulfunctions.blankSpace(height: height * 0.01, width: 0),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 24,
              itemBuilder: (ctx, index) {
                return Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: black))),
                    padding: EdgeInsets.symmetric(vertical: height * 0.1),
                    child: Center(
                        child: Text(
                      "post number ${index + 1}",
                    )));
              }),
        )
      ],
    );
  }
  void getUid(){
     User? user = FirebaseAuth.instance.currentUser;
     id = user!.uid;
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:village_project/model/post_model.dart';
import 'package:village_project/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<PostModel> lstPostModels = [
    PostModel(
        name: "Hasan bayhi",
        date: "21-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#GreatResist",
        dislike: 4,
        like: 3,
        isLike: true,
        isDislike: false),
    PostModel(
        name: "Mohamed bayhi",
        date: "08-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#ElonMusk",
        dislike: 14,
        like: 62,
        isLike: false,
        isDislike: false),
    PostModel(
        name: "Ali bayhi",
        date: "01-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "",
        dislike: 34,
        like: 76,
        isLike: true,
        isDislike: false),
    PostModel(
        name: "Fdayli bayhi",
        date: "10-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#Takwin",
        dislike: 9,
        like: 37,
        isLike: true,
        isDislike: false),
    PostModel(
        name: "Makhtar bayhi",
        date: "21-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#Resist",
        dislike: 9,
        like: 23,
        isLike: false,
        isDislike: true),
    PostModel(
        name: "Mbark bayhi",
        date: "03-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#ايغمان",
        dislike: 8,
        like: 823,
        isLike: false,
        isDislike: true),
    PostModel(
        name: "Ali bayhi",
        date: "10-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#انتخابات",
        dislike: 22,
        like: 833,
        isLike: true,
        isDislike: false),
    PostModel(
        name: "Yossef bayhi",
        date: "11-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#Izili",
        dislike: 29,
        like: 293,
        isLike: false,
        isDislike: false),
    PostModel(
        name: "Aziz bayhi",
        date: "02-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "",
        dislike: 49,
        like: 832,
        isLike: true,
        isDislike: false),
    PostModel(
        name: "Bojmaa bayhi",
        date: "02-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#اوفريت",
        dislike: 92,
        like: 83,
        isLike: false,
        isDislike: false),
    PostModel(
        name: "Mohamed bayhi",
        date: "21-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#Morphine",
        dislike: 93,
        like: 8,
        isLike: false,
        isDislike: true),
    PostModel(
        name: "Lamin bayhi",
        date: "01-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "",
        dislike: 38,
        like: 5,
        isLike: false,
        isDislike: false),
    PostModel(
        name: "Bojmaa bayhi",
        date: "21-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#اوفريت",
        dislike: 28,
        like: 13,
        isLike: false,
        isDislike: true),
    PostModel(
        name: "Mohamed bayhi",
        date: "01-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#Guelmim",
        dislike: 18,
        like: 8,
        isLike: false,
        isDislike: true),
    PostModel(
        name: "Ahmed bayhi",
        date: "01-01-2024",
        description: "lorem lsi lisd isdfie oiodsfijit isoid",
        tag: "#Tantan",
        dislike: 2,
        like: 3,
        isLike: true,
        isDislike: false),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: ListView.builder(
      itemCount: lstPostModels.length,
      itemBuilder: (ctx, index) {
        PostModel postModel = lstPostModels[index];
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.02),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: deepBlue))),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.4),
                    child: Image(
                      fit: BoxFit.cover,
                      image: const AssetImage("assets/images/youghmane.png"),
                      width: width * 0.1,
                      height: height * 0.05,
                    ),
                  ),
                  SizedBox(
                    width: height * 0.01,
                  ),
                  Expanded(
                    child: Text(postModel.getName),
                  ),
                  Text(postModel.getDate),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: postModel.getDescription,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        )),
                    TextSpan(
                        text: postModel.getTag,
                        style: const TextStyle(
                          color: deepBlue,
                          fontWeight: FontWeight.bold,
                        )),
                    const TextSpan(
                        text: " lorem lks ksdis ndsi ksi lsidf ksidn ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        )),
                  ]),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.008, left: width * 0.01),
                    child: Text(
                      "${postModel.getLike}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Icon(
                    Icons.thumb_up,
                    color: postModel.getIsLike ? deepBlue : black,
                  ),
                  SizedBox(
                    width: width * 0.08,
                  ),
                  Text(
                    "${postModel.getDislike}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Icon(
                    Icons.thumb_down,
                    color: postModel.getIsDislike ? desertOrange : black,
                  )
                ],
              )
            ],
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
        backgroundColor: white,
        onPressed: (){
            log("pressed");
        },
        child:const Text("نشر +",
            style: TextStyle(color: deepBlueDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
        ),
    );
  }
}

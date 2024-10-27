import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:village_project/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) {
          return Container(
              padding: EdgeInsets.symmetric( horizontal: width * 0.04, vertical: height * 0.02),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: deepBlue))),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.4),
                        child: Image(
                          fit: BoxFit.cover,
                          image:
                              const AssetImage("assets/images/youghmane.png"),
                          width: width * 0.1,
                          height: height * 0.05,
                        ),
                      ),
                      SizedBox(
                        width: height * 0.01,
                      ),
                      const Expanded(
                        child: Text("mahjoub Bouagrane"),
                      ),
                      const Text("12-10-2024"),
                    ],
                  ),
                  SizedBox( height: height * 0.02,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: "lorem lks ksdis ndsi ksi lsidf ksidn ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                )),
                        TextSpan(
                            text: "#Elon",
                            style: TextStyle(
                                color: deepBlue,
                                fontWeight: FontWeight.bold,
                                )),
                        TextSpan(
                            text: " lorem lks ksdis ndsi ksi lsidf ksidn ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                )),
                      ]),
                    ),
                  ),
                  SizedBox( height: height * 0.02,),
                   Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                            margin: EdgeInsets.only(top: height * 0.008, left: width * 0.02),
                            child: Text("29", style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            SizedBox( width: width * 0.02,),
                            Icon(Icons.thumb_up, color: deepBlue,),
                            SizedBox( width: width * 0.08,),
                            Text("9", style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox( width: width * 0.02,),
                            Icon(Icons.thumb_down, color: Colors.black,)
                    ],
                  )
                ],
              ));
        });
  }
}

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: 7,
        itemBuilder: (ctx, index) {
          return Container(
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.1),
                  child: Image(
                      fit: BoxFit.cover,
                    width: width * 0.2,
                    height: height * 0.1,
                    image: AssetImage("assets/images/youghmane.png"),
                  ),
                ),
                Column(
                  children: [],
                )
              ],
            ),
          );
        });
  }
}

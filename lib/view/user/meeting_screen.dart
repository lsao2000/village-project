import 'package:flutter/material.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});
  @override
  State<StatefulWidget> createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Meetings"),
    );
  }
}

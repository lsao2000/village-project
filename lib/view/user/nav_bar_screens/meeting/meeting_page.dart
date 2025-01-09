import 'package:flutter/material.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});
  @override
  State<StatefulWidget> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Aytosa",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: const Center(
        child: Text("meeting"),
      ),
    );
  }
}

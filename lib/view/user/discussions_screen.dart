import 'package:flutter/material.dart';

class DiscussionsScreen extends StatefulWidget {
  const DiscussionsScreen({super.key});
  @override
  State<StatefulWidget> createState() => DiscussionsScreenState();
}

class DiscussionsScreenState extends State<DiscussionsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Discussions"),
    );
  }
}

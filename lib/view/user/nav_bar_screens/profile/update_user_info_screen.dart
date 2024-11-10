import 'package:flutter/material.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({super.key});
  @override
  State<StatefulWidget> createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(),
          body: Center(child: Text("update info"),),
          );
  }
}

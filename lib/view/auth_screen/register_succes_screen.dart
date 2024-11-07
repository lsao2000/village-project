import 'package:flutter/material.dart';

class RegisterSuccesScreen extends StatefulWidget {
  const RegisterSuccesScreen({super.key});
  @override
  State<StatefulWidget> createState() => RegisterSuccesScreenState();
}

class RegisterSuccesScreenState extends State<RegisterSuccesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("congrat we will talk to you", style: TextStyle(fontSize: 30),),
      ),
    );
  }
}

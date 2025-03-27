import 'package:flutter/material.dart';
import 'package:village_project/utils/colors.dart';
//import 'package:village_project/constants/UsefulFunctions.dart';
//import 'package:village_project/view/user/nav_bar_screens/meeting/meeting_page.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});
  @override
  State<StatefulWidget> createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height * 0.01,
        ),
        OutlinedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  title: Center(
                    child: Text("hello"),
                  ),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.01),
                                  borderSide:
                                      const BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.01),
                                borderSide:
                                    const BorderSide(color: deepBlueDark),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.01),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.01),
                                borderSide:
                                    const BorderSide(color: Colors.black38),
                              ),
                              label: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                child: Text(
                                  "Meeting Name",
                                  style: TextStyle(color: grey),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Meeting Name";
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("create meeting"))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.blue, width: width * 0.005),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Create meeting',
            style: TextStyle(color: deepBlueDark, fontWeight: FontWeight.bold),
          ),
        )
//ElevatedButton(
        //  onPressed: () {},
        //  style: ElevatedButton.styleFrom(
        //    //backgroundColor: deepBlueDark,
        //
        //    shape: RoundedRectangleBorder(
        //
        //      borderRadius: BorderRadius.circular(12), // <-- Radius
        //    ),
        //  ),
        //  child: const Text(
        //    ',
        //    style: TextStyle(color: deepBlueDark),
        //  ),
        //),
      ],
    );
  }
}

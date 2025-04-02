import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_project/constants/UsefulFunctions.dart';
import 'package:village_project/controller/providers/auth_provider/ighoumane_user_provider.dart';
import 'package:village_project/controller/services/dio_services/http_services.dart';
import 'package:village_project/controller/services/firebase_services/meeting_services/meeting_logic_services.dart';
import 'package:village_project/model/meeting_model.dart';
import 'package:village_project/model/user_ighoumane_freind.dart';
import 'package:village_project/utils/colors.dart';
import 'package:village_project/view/user/nav_bar_screens/meeting/meeting_page.dart';

enum MeetingRole { public, private }

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});
  @override
  State<StatefulWidget> createState() => MeetingScreenState();
}

class MeetingScreenState extends State<MeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  MeetingRole? roleType = MeetingRole.public;
  List<String> invitedFreinds = [];
  List<String> invitedFreindsIds = [];
  List<Map<String, dynamic>> freindslistTest = [];
  //List<MeetingModel> lstAllMeetings = [];
  TextEditingController meetingTitle = TextEditingController();

  @override
  void initState() {
    //lstAllMeetings =
    //    Provider.of<IghoumaneUserProvider>(context, listen: false).lstMeetings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    IghoumaneUserProvider ighoumaneUserProvider =
        context.read<IghoumaneUserProvider>();
    List<UserIghoumaneFreind> lstFreinds = ighoumaneUserProvider.lstFreinds;

    String currentUserId =
        context.read<IghoumaneUserProvider>().ighoumaneUser.getUserId;
    setState(() {
      freindslistTest = lstFreinds.map((el) {
        return {
          "name": "${el.getFirstName} ${el.getastName}",
          "id": el.getId,
          "invited": false
        };
      }).toList();
    });
    //return RefreshIndicator(
    //  color: Colors.black,
    //  onRefresh: () async {
    //    return await _refreshData(ctx: context);
    //  },
    //  child: meetingInfo(currentUserId: currentUserId),
    //);

    return Column(
      children: [
        SizedBox(
          height: height * 0.01,
        ),
        createMeeting(
            width: width,
            height: height,
            lstFreinds: lstFreinds,
            ighoumaneUserProvider: ighoumaneUserProvider,
            currentUserId: currentUserId),
        meetingInfo(currentUserId: currentUserId),
      ],
    );
  }

  Future<void> _refreshData({required BuildContext ctx}) async {
    MeetingLogicServices.getAllTodayMeeting(ctx: ctx);
  }

  Widget createMeeting(
      {required double width,
      required double height,
      required List<UserIghoumaneFreind> lstFreinds,
      required IghoumaneUserProvider ighoumaneUserProvider,
      required String currentUserId}) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            MeetingRole? mRole = roleType;

            return StatefulBuilder(builder: (ctx, setState) {
              return AlertDialog(
                backgroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                title: Center(
                  child: Text("Meeting"),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: meetingTitle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.01),
                                borderSide:
                                    const BorderSide(color: Colors.black38)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.01),
                              borderSide: const BorderSide(color: deepBlueDark),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.01),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.01),
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
                        Usefulfunctions.blankSpace(
                            width: width, height: height * 0.02),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              freindslistTest = lstFreinds
                                  .map((el) {
                                    return {
                                      "name":
                                          "${el.getFirstName} ${el.getastName}",
                                      "id": el.getId,
                                      "invited":
                                          invitedFreindsIds.contains(el.getId)
                                    };
                                  })
                                  .where((el) =>
                                      el["name"].toString().contains(value))
                                  .toList();
                            });
                          },
                          validator: (value) {
                            if (invitedFreindsIds.isEmpty) {
                              return "Meeting should have at least two person";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: deepBlue,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.01),
                                borderSide:
                                    const BorderSide(color: Colors.black38)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.01),
                              borderSide: const BorderSide(color: deepBlueDark),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.01),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.01),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            label: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01),
                              child: Text(
                                "Freind username",
                                style: TextStyle(color: grey),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.1,
                          width: width,
                          child: ListView.builder(
                              itemCount: freindslistTest.length,
                              itemBuilder: (item, index) {
                                Map<String, dynamic> freind =
                                    freindslistTest[index];
                                bool invited =
                                    invitedFreindsIds.contains(freind["id"]);
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  child: Row(
                                    children: [
                                      Usefulfunctions.blankSpace(
                                          width: width * 0.01, height: 0),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.7),
                                        child: Image(
                                          fit: BoxFit.fill,
                                          image: const AssetImage(
                                              "assets/images/youghmane.png"),
                                          width: width * 0.155,
                                          height: height * 0.07,
                                        ),
                                      ),
                                      Usefulfunctions.blankSpace(
                                          width: width * 0.03, height: 0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              freind["name"].toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: black),
                                            ),
                                            //Text(
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          String name =
                                              freind["name"].toString();
                                          String id = freind["id"].toString();
                                          if (invited) {
                                            setState(() {
                                              int itemIndex =
                                                  invitedFreindsIds.indexOf(id);
                                              invitedFreindsIds.remove(id);
                                              invitedFreinds
                                                  .removeAt(itemIndex);
                                              freind["invited"] = false;
                                            });
                                          } else {
                                            setState(() {
                                              invitedFreinds.add(name);
                                              invitedFreindsIds.add(id);
                                              freind["invited"] = true;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: deepBlue),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          invited ? "Cancel" : "Invite",
                                          style: TextStyle(
                                              color: deepBlue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Usefulfunctions.blankSpace(
                            width: width, height: height * 0.01),
                        // display invited freinds
                        SizedBox(
                          width: width,
                          height: height * 0.035,
                          child: ListView.builder(
                              itemCount: invitedFreinds.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                String freindName = invitedFreinds[index];
                                return Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * .001,
                                      horizontal: width * .02),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.1),
                                      border:
                                          Border.all(width: 2, color: black38)),
                                  child: Text(
                                    freindName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: black38),
                                  ),
                                );
                              }),
                        ),
                        Usefulfunctions.blankSpace(
                            width: width, height: height * 0.02),
                        Column(
                          children: [
                            ListTile(
                              minVerticalPadding: 0,
                              title: Text(MeetingRole.public.name),
                              iconColor: Colors.blue,
                              leading: Radio<MeetingRole>(
                                activeColor: Colors.blue,
                                value: MeetingRole.public,
                                groupValue: mRole,
                                onChanged: (MeetingRole? value) {
                                  setState(() {
                                    mRole = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text(MeetingRole.private.name),
                              leading: Radio<MeetingRole>(
                                value: MeetingRole.private,
                                groupValue: mRole,
                                activeColor: Colors.blue,
                                onChanged: (MeetingRole? value) {
                                  setState(() {
                                    mRole = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Usefulfunctions.blankSpace(
                            width: width, height: height * 0.02),
                        ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.blue, width: width * 0.005),
                            backgroundColor: white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (invitedFreindsIds.isNotEmpty) {
                                //Navigator.pop(context);
                                var httpServices = HttpServices();
                                String? token = await httpServices.getToken();
                                token != null
                                    ? MeetingLogicServices.createMeeting(
                                            meetingtoken: token,
                                            invitedUsers: invitedFreindsIds,
                                            roleType: mRole!.name,
                                            currentUserId: currentUserId,
                                            joinedUsers: [currentUserId],
                                            meetingStatus: "OnGoing",
                                            title: meetingTitle.text)
                                        .then((value) {
                                        if (value != null) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => MeetingPage(
                                                token: token,
                                                meetingId: value,
                                              ),
                                            ),
                                          );
                                        }
                                      })
                                    : null;
                              }
                            }
                          },
                          child: Text(
                            "Create & Join",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.blue, width: width * 0.005),
                            backgroundColor: white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (invitedFreindsIds.isNotEmpty) {
                                String currentUserId = context
                                    .read<IghoumaneUserProvider>()
                                    .ighoumaneUser
                                    .getUserId;
                                var httpServices = HttpServices();
                                String? token = await httpServices.getToken();
                                token != null
                                    ? MeetingLogicServices.createMeeting(
                                        meetingtoken: token,
                                        invitedUsers: invitedFreindsIds,
                                        roleType: mRole!.name,
                                        currentUserId: currentUserId,
                                        joinedUsers: [],
                                        meetingStatus: "Offline",
                                        title: meetingTitle.text.trim())
                                    : null;
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(
                            "Create",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
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
    );
  }

  Widget meetingInfo({required String currentUserId}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Consumer<IghoumaneUserProvider>(builder: (ctx, value, child) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            _refreshData(ctx: context);
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.01),
            //shrinkWrap: true, // Add this
            //physics: NeverScrollableScrollPhysics(), // Add this
            itemCount: value.lstMeetings.length,
            itemBuilder: (ctx, index) {
              MeetingModel meetingModel = value.lstMeetings[index];
              return Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.01),
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.03),
                decoration: BoxDecoration(
                    color: deepBlueDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: deepBlue)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.004,
                              horizontal: width * 0.02),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(width * 0.2)),
                          child: Text(
                            meetingModel.meetingStatus.toUpperCase(),
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await MeetingLogicServices.updateMeetingStatus(
                                    ctx: context,
                                    id: meetingModel.meetingId,
                                    meetingStatus: "OnGoing",
                                    leaveChannel: false,
                                    userId: currentUserId)
                                .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => MeetingPage(
                                    token: meetingModel.token,
                                    meetingId: meetingModel.meetingId,
                                  ),
                                ),
                              );
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: white,
                          ),
                          child: Text(
                            "Join",
                            style: TextStyle(
                                color: deepBlueDark,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      meetingModel.title,
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05),
                    ),
                    Text(
                      meetingModel.roleType.name,
                      style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.03),
                    ),
                    Usefulfunctions.blankSpace(
                        width: 0, height: height * 0.005),
                    Builder(builder: (ctx) {
                      int itemCount = meetingModel.joinedUsers.length;
                      if (itemCount == 0) {
                        return Text("");
                      }
                      if (itemCount > 4) {
                        int others = itemCount - 4;
                        return SizedBox(
                          height: height * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (ctx, index) {
                              // joined users ids not name i will add this feature in the future inchallah
                              String joinedUserId = meetingModel
                                  .joinedUsers[index]
                                  .substring(0, 2)
                                  .toUpperCase();
                              if (index == 3) {
                                return Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: width * .01),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.03,
                                          vertical: height * .014),
                                      decoration: BoxDecoration(
                                        color: Colors.white54,
                                        borderRadius:
                                            BorderRadius.circular(width * .1),
                                        border: Border.all(
                                            color: deepBlueDark, width: 0),
                                      ),
                                      child: Text(
                                        joinedUserId,
                                        //meetingModel.meetingId
                                        //    .substring(0, 2)
                                        //    .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: white),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: width * .01),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.03,
                                          vertical: height * .014),
                                      decoration: BoxDecoration(
                                        color: Colors.white54,
                                        borderRadius:
                                            BorderRadius.circular(width * .1),
                                        border: Border.all(
                                            color: deepBlueDark, width: 0),
                                      ),
                                      child: Text(
                                        "+$others",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: white),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: width * .01),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * .014),
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        borderRadius:
                                            BorderRadius.circular(width * .1),
                                        border: Border.all(
                                            color: deepBlueDark, width: 0)),
                                    child: Text(
                                      joinedUserId,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        height: height * 0.15,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            String joinedUserId = meetingModel
                                .joinedUsers[index]
                                .substring(0, 2)
                                .toUpperCase();
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * .014),
                                  decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius:
                                          BorderRadius.circular(width * .1),
                                      border: Border.all(
                                          color: deepBlueDark, width: 0)),
                                  child: Text(
                                    joinedUserId,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: white),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

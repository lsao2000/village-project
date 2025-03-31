import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:village_project/view/user/nav_bar_screens/meeting/meeting_screen.dart';

class MeetingModel {
  late String token;
  late String meetingId;
  late String title;
  late MeetingRole roleType;
  late List<String> invitedUserIds;
  late String meetingStatus;
  late DateTime createdAt;
  MeetingModel({
    required this.meetingId,
    required this.token,
    required this.title,
    required this.roleType,
    required this.createdAt,
    required this.meetingStatus,
    required this.invitedUserIds,
  });

  static MeetingModel fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>> meeting) {
    var id = meeting.id;
    Timestamp createdDate = meeting["createdAt"];
    List<dynamic> ids = meeting["invitedUsers"];
    MeetingModel meetingModel = MeetingModel(
        meetingId: id,
        token: meeting["meetingToken"],
        title: meeting["title"],
        roleType: meeting["roleType"] == ("public")
            ? MeetingRole.public
            : MeetingRole.private,
        meetingStatus: meeting["status"],
        invitedUserIds: ids.map((el) => el.toString()).toList(),
        createdAt: createdDate.toDate());
    return meetingModel;
  }

  @override
  String toString() {
    return "Meeting: [$meetingId, $token, $title, $roleType, $meetingStatus, $invitedUserIds, $createdAt]";
  }
}

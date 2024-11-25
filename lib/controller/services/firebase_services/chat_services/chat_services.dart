import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/user.dart';

class ChatServices {
  static Future<IghoumaneUser> getPosterInfo({required String userId}) async {
    var data = await db.collection("users").doc(userId).get();
    IghoumaneUser ighoumaneUser =
        IghoumaneUser.basicInfo(data["firstName"], data["lastName"]);
    return ighoumaneUser;
  }
}

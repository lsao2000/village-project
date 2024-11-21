import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:village_project/controller/services/firebase_services/user_services.dart';
import 'package:village_project/model/user.dart';

class SearchUserServices {
  static Future<QuerySnapshot> searchUsers({required String query}) async {
    final querySnapshot = await db
        .collection("users")
        .where("firstName", isGreaterThanOrEqualTo: query)
        .where("firstName", isLessThanOrEqualTo: "$query,")
        //.where("lastName", isGreaterThanOrEqualTo: query)
        //.where("lastName", isLessThanOrEqualTo: "$query,")
        .get();
    return querySnapshot;
    //List<IghoumaneUser> lstUsers = querySnapshot.docs
    //    .map((el) => IghoumaneUser.getUserFromQuerySnapshot(el))
    //    .toList()
    //    .where((el) {
    //  //return  query.contains(el.getFirstName)  || query.contains(el.getLastName);
    //  //el.getFirstName.contains(query);
    //  return el.getFirstName.contains(query) ||
    //      el.getLastName.contains(query);
    //}).toList();
    //return lstUsers;
    //print("error ${e.toString()}");
  }
}

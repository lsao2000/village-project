import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationServices {
  static addUserInFirestore() {
      CollectionReference users = FirebaseFirestore.instance.collection("JoinedUsers");
      DocumentReference newJoinedUserRef = users.doc();
      String userId = newJoinedUserRef.id;
      newJoinedUserRef.set({});
  }
}

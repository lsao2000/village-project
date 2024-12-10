import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPresenceServices {
  Future<void> initUserPresence() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("users/$userId");
      //await databaseReference.update({"status": "online"});
      databaseReference.onValue.listen((event) async {
        print("------------------${event.snapshot.value.toString()}");
        await databaseReference.update({"status": "online"});
        databaseReference.onDisconnect().update({"status": "offline"});
      });
      print("all done");
    } catch (e) {
      print("error ${e.toString()}");
    }
  }
}

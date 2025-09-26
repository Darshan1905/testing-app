import 'package:firebase_database/firebase_database.dart';
import 'package:occusearch/utility/utils.dart';

class FirebaseDatabaseController {
  // GET data from Firebase RealTime database
  static Future<Object?> getRealtimeData({required String key}) async {
    //Call instance of FirebaseDatabase
    FirebaseDatabase database = FirebaseDatabase.instance;

    //Pass the string from where you want to read the database
    DatabaseReference reference = database.ref(key);

    final event = await reference.once(DatabaseEventType.value);
    if (event.snapshot.value != null && event.snapshot.value != "") {
      printLog("RealtimeDatabase response ${event.snapshot.value}");
      return event.snapshot.value;
    } else {
      return null;
    }
  }
}

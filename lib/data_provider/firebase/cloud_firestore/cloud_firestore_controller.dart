import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/cloud_firestore/cloud_firestore_constants.dart';

class FirestoreController {
  FirebaseFirestore fireStoreDB = FirebaseFirestore.instance;

  sendEmailWithTemplate(String? subjectName,
      {required BuildContext? dialogContext,
      required String templateName,
      required String filename,
      required String? name,
      required String file,
      required String email}) async {
    String? docId = "";
    var ref = fireStoreDB.collection(CloudFirestoreConstants.emails).doc();
    docId = ref.id;
    ref.set({
      "to": email,
      "template": {
        "name": templateName,
        "data": {
          "subject": subjectName ?? "",
          "username": name ?? "",
          "name": name ?? "",
          "filename": filename,
          "content": file,
          "encoding": 'base64',
        }
      }
    }).then((value) {
      handleResult(templateName, dialogContext: dialogContext, id: docId);
    });
  }

  Future<void> handleResult(String? key,
      {required BuildContext? dialogContext, required String? id}) async {
    FirebaseFirestore.instance
        .collection(CloudFirestoreConstants.emails)
        .doc(id)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.get("delivery");
        String status = data!["state"];
        printLog(data["state"]);

        if (status == CloudFirestoreConstants.success) {
          LoadingWidget.hide();
          Toast.show(dialogContext!,
              message: (key == CloudFirestoreConstants.pointTestTemplate)
                  ? "Point score report file sent, Please check your email."
                  : "Visa fees report pdf sent, Please check your email.",
              gravity: Toast.toastTop,
              duration: 2);
        } else if (status == CloudFirestoreConstants.error) {
          LoadingWidget.hide();
          Toast.show(dialogContext!,
              message: StringHelper.emailSendFailedMessage,
              gravity: Toast.toastTop,
              type: Toast.toastError,
              duration: 2);
        }
      }
    });
  }
}

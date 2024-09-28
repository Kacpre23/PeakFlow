import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUser(String userId, Map<String, dynamic> userInfoMap) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(userInfoMap);
  }
}

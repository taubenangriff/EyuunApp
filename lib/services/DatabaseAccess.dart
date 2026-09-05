import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseAccess {
  Future<Map<String, dynamic>?> getGameObject(
      String sessionKey, String objectId);
}

class FirebaseAccess implements DatabaseAccess {
  @override
  Future<Map<String, dynamic>?> getGameObject(
      String sessionKey, String objectId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(sessionKey)
        .doc(objectId)
        .get();

    return snapshot.exists ? snapshot.data() : null;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyuunapp/model/CharacterMetaInfo.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:eyuuncore/io/SessionData.dart';
import 'package:oxygen/oxygen.dart';

abstract class DatabaseAccess {
  Future<Map<String, dynamic>?> getGameObjectData(
      String sessionKey, String objectId);

  Future<List<Map<String, dynamic>>> getGameObjectIds(String sessionKey);

  Future<void> postGameObject(
      String sessionKey, String objectId, Entity gameObject);

  Future<SessionData?> getSessionData(String sessionKey);

  Future<void> postSessionData(String sessionKey, SessionData sessionData);

  Future<CharacterMetaInfo?> getCharacterMetaInfo(String sessionKey);

  Future<void> postCharacterMetaInfo(
      String sessionKey, CharacterMetaInfo characterMetaInfo);

  Future<List<String>> getSessionKeys();

  Future<String?> getLastSession();

  Future<void> setLastSession(String sessionId);
}

class FirebaseAccess implements DatabaseAccess {
  @override
  Future<Map<String, dynamic>?> getGameObjectData(
      String sessionKey, String objectId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .collection('gameObjects')
        .doc(objectId)
        .get();
    return snapshot.exists ? snapshot.data() : null;
  }

  @override
  Future<List<Map<String, dynamic>>> getGameObjectIds(String sessionKey) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .collection('gameObjects')
        .get();

    return snapshot.docs.map((document) => document.data()).toList();
  }

  @override
  Future<void> postGameObject(
      String sessionKey, String objectId, Entity entity) {
    var map = locator<AssetSerializer>().serialize(entity);

    return FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .collection('gameObjects')
        .doc(objectId)
        .set(map);
  }

  @override
  Future<SessionData?> getSessionData(String sessionKey) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .get();
    if (!snapshot.exists) return null;

    return SessionDataMapper.fromMap(snapshot.data()!);
  }

  @override
  Future<void> postSessionData(String sessionKey, SessionData sessionData) {
    return FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .set(sessionData.toMap());
  }

  @override
  Future<CharacterMetaInfo?> getCharacterMetaInfo(String sessionKey) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .collection('meta')
        .doc('info')
        .get();
    return snapshot.exists
        ? CharacterMetaInfoMapper.fromMap(snapshot.data()!)
        : null;
  }

  @override
  Future<void> postCharacterMetaInfo(
      String sessionKey, CharacterMetaInfo characterMetaInfo) {
    return FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionKey)
        .collection('meta')
        .doc('info')
        .set(characterMetaInfo.toMap());
  }

  @override
  Future<List<String>> getSessionKeys() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('sessions').get();

    return snapshot.docs.map((document) => document.id).toList();
  }

  @override
  Future<String?> getLastSession() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('meta')
        .doc('last_session')
        .get();
    final sessionId = snapshot.data()?['sessionId'];

    return sessionId is String ? sessionId : null;
  }

  @override
  Future<void> setLastSession(String sessionId) {
    return FirebaseFirestore.instance
        .collection('meta')
        .doc('last_session')
        .set({'sessionId': sessionId});
  }
}

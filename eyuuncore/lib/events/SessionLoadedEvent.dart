import 'package:oxygen/oxygen.dart';

class SessionLoadedEvent {
  String sessionId;
  Entity character;
  SessionLoadedEvent(this.sessionId, this.character);
}

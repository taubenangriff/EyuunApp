import 'package:oxygen/oxygen.dart';

class SessionCreatedEvent {
  String sessionId;
  Entity character;

  SessionCreatedEvent(this.sessionId, this.character);
}

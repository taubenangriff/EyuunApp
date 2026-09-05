import 'package:oxygen/oxygen.dart';

class SessionLeaveEvent {
  String sessionId;
  Entity character;
  SessionLeaveEvent(this.sessionId, this.character);
}

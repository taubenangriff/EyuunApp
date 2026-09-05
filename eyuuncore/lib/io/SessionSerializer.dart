import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:eyuuncore/io/SessionData.dart';
import 'package:oxygen/oxygen.dart';

import '../GetIt.dart';

class SessionSerializer {
  SessionSerializer();

  SessionData exportGameObjects(List<Entity> entities) {
    SessionData export = SessionData.empty();

    for (var entity in entities) {
      export.gameObjects.add(entity.getObjectId());
    }

    return export;
  }
}

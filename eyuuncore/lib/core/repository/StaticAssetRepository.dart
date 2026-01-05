import 'package:eyuuncore/core/components/standard.dart';
import 'package:oxygen/oxygen.dart';

class StaticAssetRepository {
  Map<String, Entity> staticAssets = {};

  void register(String typeId, Entity entity) {
    if(entity.get<StandardComponent>()?.typeId != typeId)
    {
      Exception("typeId of this entity must match the typeId in it's Standard component!");
    }

    staticAssets[typeId] = entity;
  }

  bool contains(String typeId) => staticAssets.containsKey(typeId);

  Entity? getAssetData(String typeId) {
    return staticAssets[typeId];
  }
}
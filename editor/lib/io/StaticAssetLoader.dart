import 'package:editor/Asset.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';

class StaticAssetLoader {

  ComponentRepository componentRepository;

  StaticAssetLoader(this.componentRepository);

  Map<String, dynamic> toMap(Asset asset) {
    return <String, dynamic>{};
  }

  Asset loadAsset(Map<String, dynamic> jsonMap) {
    var asset = Asset();

    for(var key in jsonMap.keys){
      if(componentRepository.isComponent(key)){

        var submap = jsonMap[key];

        var comp = componentRepository.fromMap(key, submap);
        if(comp != null)
        {
          asset.components.add(comp);
        }

      }
    }
    return asset;
  }
}
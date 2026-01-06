import 'package:eyuuncore/components/text.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:oxygen/oxygen.dart';

extension EntityIdExtension on Entity {

  String getTextKey() {
    if(has<TextComponent>()){
      var textComponent = get<TextComponent>();
      if(textComponent!.textOverride != null){
        return textComponent.textOverride!;
      }
    }
    return getTypeId();
  }

  String? getFluff() {
    if(has<TextComponent>()){
      return get<TextComponent>()?.fluff;
    }
    return null;
  }

  String? getShort() {
    if(has<TextComponent>()){
      return get<TextComponent>()?.short;
    }
    return null;
  }

  String getObjectId() {
    if(!this.has<StandardComponent>()){
      throw Error();
    }

    return this.get<StandardComponent>()!.objectId;
  }

  String getTypeId() {
    if(!this.has<StandardComponent>()){
      throw Error();
    }

    return this.get<StandardComponent>()!.typeId;
  }
}
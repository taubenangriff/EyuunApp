import 'package:eyuuncore/components/text.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/repository/TextRepository.dart';
import 'package:oxygen/oxygen.dart';

import '../assetLink.dart';
import '../registerServices.dart';

class TextService {
  late TextRepository _textRepository;
  late GameObjectService _gameObjectService;

  TextService() {
    _textRepository = locator<TextRepository>();
    _gameObjectService = locator<GameObjectService>();
  }

  String getTextFromEntity(Entity? entity) {
    if(entity == null){
      return "!No Entity";
    }
    return getText(entity.getTextKey());
  }

  String getFluffFromEntity(Entity? entity) {
    if(entity == null){
      return "!No Entity";
    }
    var fluff = entity.getFluff();
    if(fluff == null){
      return "";
    }
    return getText(fluff);
  }

  String getText(String textLookup)
  {
    return _textRepository.getText(getTextKey(textLookup));
  }

  String getTextFromLink(AssetLink textLink) => getText(textLink.id);

  bool hasFluff(String typeId)
  {
    return _gameObjectService.getStatic(typeId)?.get<TextComponent>()?.fluff != null;
  }

  String getFluff(String typeId)
  {
    return _textRepository.getText(getFluffKey(typeId));
  }

  String getFluffFromLink(AssetLink textLink) => getFluff(textLink.id);

  String getShort(String typeId)
  {
    return _textRepository.getText(getShortKey(typeId));
  }

  String getShortFromLink(AssetLink textLink) => getFluff(textLink.id);

  String getTextKey(String typeId) {
    var entity = _gameObjectService.getStatic(typeId);
    return entity?.getTextKey() ?? typeId;
  }

  String getFluffKey(String typeId) {
    var entity = _gameObjectService.getStatic(typeId);
    return entity?.getFluff() ?? typeId;
  }

  String getShortKey(String typeId) {
    var entity = _gameObjectService.getStatic(typeId);
    return entity?.getShort() ?? typeId;
  }
}
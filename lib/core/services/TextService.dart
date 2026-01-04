import 'package:EyuunApp/components/text.dart';
import 'package:EyuunApp/core/components/EntityExtensions.dart';
import 'package:EyuunApp/core/services/assetloader.dart';
import 'package:EyuunApp/core/repository/TextRepository.dart';
import 'package:oxygen/oxygen.dart';

import '../assetLink.dart';
import '../registerServices.dart';

class TextService {
  late TextRepository _textRepository;
  late AssetLoader _assetLoader;

  TextService() {
    _assetLoader = locator<AssetLoader>();
    _textRepository = locator<TextRepository>();
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
    return _textRepository.getText(_assetLoader.getTextKey(textLookup));
  }

  String getTextFromLink(AssetLink textLink) => getText(textLink.id);

  bool hasFluff(String typeId)
  {
    return _assetLoader.getStatic(typeId)?.get<TextComponent>()?.fluff != null;
  }

  String getFluff(String typeId)
  {
    return _textRepository.getText(_assetLoader.getFluffKey(typeId));
  }

  String getFluffFromLink(AssetLink textLink) => getFluff(textLink.id);

  String getShort(String typeId)
  {
    return _textRepository.getText(_assetLoader.getShortKey(typeId));
  }

  String getShortFromLink(AssetLink textLink) => getFluff(textLink.id);
}
import 'package:EyuunApp/core/services/assetloader.dart';
import 'package:EyuunApp/core/repository/TextRepository.dart';

import '../assetLink.dart';
import '../registerServices.dart';

class TextService {
  late TextRepository _textRepository;
  late AssetLoader _assetLoader;

  TextService() {
    _assetLoader = locator<AssetLoader>();
    _textRepository = locator<TextRepository>();
  }

  String getText(String textLookup)
  {
    return _textRepository.getText(_assetLoader.getTextKey(textLookup));
  }

  String getTextFromLink(AssetLink textLink) => getText(textLink.id);

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
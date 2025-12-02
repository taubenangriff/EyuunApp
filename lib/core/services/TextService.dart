import 'package:flexbackend/core/services/assetloader.dart';
import 'package:flexbackend/core/repository/TextRepository.dart';

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

  String getFluff(String typeId)
  {
    return _textRepository.getText(_assetLoader.getFluffKey(typeId));
  }

  String getShort(String typeId)
  {
    return _textRepository.getText(_assetLoader.getShortKey(typeId));
  }
}
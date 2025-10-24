import 'package:flexbackend/core/assetloader.dart';
import 'package:flexbackend/core/TextRepository.dart';

import 'registerServices.dart';

class TextHelper {
  String getText(String textLookup)
  {
    return locator<TextRepository>().getText(locator<AssetLoader>().getTextKey(textLookup));
  }
}
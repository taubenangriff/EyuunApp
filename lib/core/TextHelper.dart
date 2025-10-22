import 'package:flexbackend/core/assetloader.dart';
import 'package:flexbackend/core/TextRepository.dart';

class TextHelper {
  static String getText(String textLookup)
  {
    return TextRepository.instance.getText(AssetLoader.instance.getTextKey(textLookup));
  }
}
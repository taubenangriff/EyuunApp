import 'package:flexbackend/io/assetloader.dart';
import 'TextRepository.dart';

class TextHelper {
  static String getText(String textLookup)
  {
    return TextRepository.instance.getText(AssetLoader.instance.getTextKey(textLookup));
  }
}
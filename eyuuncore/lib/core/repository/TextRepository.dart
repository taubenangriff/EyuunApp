import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/services.dart';

part 'TextRepository.mapper.dart';


@MappableClass()
class Texts with TextsMappable {
  Map<String, String> texts;

  Texts(this.texts);

  static const fromMap = TextsMapper.fromMap;
}

class TextRepository {
  Map<String, String> _texts = {};

  String getText(String key)
  {
    if(_texts.containsKey(key)){
      return _texts[key]!;
    }

    return "¿" +  key.toString() + "?";
  }

  Future<void> reloadTexts(String textFile) async {
    final String response = await rootBundle.loadString(textFile);
    Map<String, dynamic> data = await json.decode(response);
    var loadedTexts = Texts.fromMap(data);
    _texts = loadedTexts.texts;
  }

}
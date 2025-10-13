class TextRepository {
  static const Map<String, String> _texts = {
    "text_courage" : "Courage",
    "text_intelligence" : "Intelligence"
  };

  static late TextRepository instance = TextRepository();

  String getText(String key)
  {
    if(_texts.containsKey(key)){
      return _texts[key]!;
    }

    return "¿" +  key.toString() + "?";
  }

}
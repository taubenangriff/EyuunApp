class TextRepository {
  static const Map<String, String> _texts = {
    "Text_Courage" : "Courage",
    "Text_Intelligence" : "Intelligence"
  };

  String getText(String key)
  {
    if(_texts.containsKey(key)){
      return _texts[key]!;
    }

    return "¿" +  key.toString() + "?";
  }

}
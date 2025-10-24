class TextRepository {
  static const Map<String, String> _texts = {
    "baseSkill_Courage" : "Mut",
    "baseSkill_Intelligence" : "Intelligenz",
    "text_increase": "Randomize"
  };

  String getText(String key)
  {
    if(_texts.containsKey(key)){
      return _texts[key]!;
    }

    return "¿" +  key.toString() + "?";
  }

}
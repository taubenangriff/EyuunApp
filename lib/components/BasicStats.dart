import 'package:flexbackend/components/EyuunComponent.dart';

enum BasicStat { courage, intelligence, intuition, charisma, dexterity, agility, constitution, strength }

class BasicStatsComponent extends EyuunComponent<int> {
  static const String propertyName = "basicStats";

  late Map<String, int> statValues;

  @override
  void applyValues(Map<String, dynamic> valueMap) {
    //only apply the values that are loaded into the map from the asset itself.
    Map<String, dynamic> persistedStatValues = valueMap['statValues'];

    for(var key in persistedStatValues.keys) {
      if(!statValues.containsKey(key)) {
        continue;
      }
      statValues[key] = persistedStatValues[key];
    }
  }

  @override
  String getName() => propertyName;

  @override
  void init([data]) {
    reset();
  }

  @override
  void reset() {
    statValues = {};
  }

  @override
  Map<String, dynamic> persist() {
    return {
      'stats': statValues
    };
  }

}
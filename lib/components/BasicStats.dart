import 'package:flexbackend/components/EyuunComponent.dart';

import '../enums/dice.dart';

class BasicStatEntry {
  late String stat;
  late int dice;

  BasicStatEntry();
  BasicStatEntry.from(this.stat, this.dice);

  Map<String, dynamic> toJSON() {
    return {
      'stat' : stat,
      'dice' : dice
    };
  }
}

class BasicStatsComponent extends EyuunComponent<int> {
  static const String propertyName = "basicStats";

  late List<BasicStatEntry> statValues;

  @override
  void applyValues(Map<String, dynamic> valueMap) {
    //only apply the values that are loaded into the map from the asset itself.
    Map<String, dynamic> persistedStatValues = valueMap['statValues'];

    for(var key in persistedStatValues.keys) {
      if(!statValues.any((x) => x.stat == key)) {
        continue;
      }
      statValues.firstWhere((x) => x.stat == key).dice = persistedStatValues[key] as int;
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
    statValues = [];
  }

  @override
  Map<String, dynamic> persist() {
    return {
      'stats': statValues.map((e) => e.toJSON()).toList()
    };
  }

}
import 'package:flexbackend/components/EyuunComponent.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'BasicStats.mapper.dart';

@MappableClass()
class BasicStatsDynamic with BasicStatsDynamicMappable {
  List<BasicStatEntry> statValues;
  BasicStatsDynamic(this.statValues);
}

@MappableClass()
class BasicStatsStatic with BasicStatsStaticMappable {
  List<BasicStatEntryStatic> statValues;
  BasicStatsStatic(this.statValues);
}

@MappableClass()
class BasicStatEntry with BasicStatEntryMappable {
  String stat;
  int dice;

  BasicStatEntry(this.stat, this.dice);
}

@MappableClass()
class BasicStatEntryStatic with BasicStatEntryStaticMappable{
  String stat;
  BasicStatEntryStatic(this.stat);
}

class BasicStatsComponent extends EyuunComponent<int> {
  static const String propertyName = "basicStats";

  late List<BasicStatEntry> statValues;

  BasicStatEntry? getStatEntry(String basicStatName){
    return statValues.firstWhere((e) => e.stat == basicStatName, orElse: null);
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
  Map<String, dynamic> saveDynamicData() {
    return BasicStatsDynamic(statValues).toMap();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = BasicStatsDynamicMapper.fromMap(dynamicData);
    statValues = dyn.statValues;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = BasicStatsStaticMapper.fromMap(staticData);
    statValues = stat.statValues.map((e) => BasicStatEntry(e.stat, 0)).toList();
  }

}
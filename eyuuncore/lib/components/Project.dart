import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/assetLink.dart';

part 'Project.mapper.dart';

@MappableClass()
@reflector
class ProjectStatic with ProjectStaticMappable, ComponentReflectable {
  int reachThreshold;
  bool useInfiniteThreshold;
  AssetLink itemOnCompletion;
  AssetLink resourceOnCompletion;
  int resourceOnCompletionAmount;
  int moneyOnCompletion;
  String prerequisiteDescription;
  String onCompletedDescription;
  bool useItemCost;
  double useItemCostFactor;

  ProjectStatic(
      this.reachThreshold,
      this.useInfiniteThreshold,
      this.itemOnCompletion,
      this.resourceOnCompletion,
      this.resourceOnCompletionAmount,
      this.moneyOnCompletion,
      this.prerequisiteDescription,
      this.onCompletedDescription,
      this.useItemCost,
      this.useItemCostFactor);
}

@MappableClass()
class ProjectDynamic with ProjectDynamicMappable {
  int currentProgress;

  ProjectDynamic(this.currentProgress);
}

class ProjectComponent extends EyuunComponent<int> {
  static const String propertyName = "project";

  late int reachThreshold;
  late bool useInfiniteThreshold;
  late AssetLink itemOnCompletion;
  late AssetLink resourceOnCompletion;
  late int resourceOnCompletionAmount;
  late int moneyOnCompletion;
  late String prerequisiteDescription;
  late String onCompletedDescription;
  late bool useItemCost;
  late double useItemCostFactor;

  late int currentProgress;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = ProjectDynamicMapper.fromMap(dynamicData);
    currentProgress = dyn.currentProgress;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ProjectStaticMapper.fromMap(staticData);
    reachThreshold = stat.reachThreshold;
    useInfiniteThreshold = stat.useInfiniteThreshold;
    itemOnCompletion = stat.itemOnCompletion;
    resourceOnCompletion = stat.resourceOnCompletion;
    resourceOnCompletionAmount = stat.resourceOnCompletionAmount;
    moneyOnCompletion = stat.moneyOnCompletion;
    prerequisiteDescription = stat.prerequisiteDescription;
    onCompletedDescription = stat.onCompletedDescription;
    useItemCost = stat.useItemCost;
    useItemCostFactor = stat.useItemCostFactor;
  }

  @override
  void reset() {
    reachThreshold = 0;
    useInfiniteThreshold = false;
    itemOnCompletion = AssetLink.invalid();
    resourceOnCompletion = AssetLink.invalid();
    resourceOnCompletionAmount = 0;
    moneyOnCompletion = 0;
    prerequisiteDescription = "";
    onCompletedDescription = "";
    useItemCost = false;
    useItemCostFactor = 1;
    currentProgress = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() =>
      ProjectDynamic(currentProgress).toMap();
}

import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'Cost.mapper.dart';

@MappableClass()
class CostEntry with CostEntryMappable {
  /// AssetLink to the resource needed to buy
  AssetLink resource;
  /// The amount of this resource needed
  int amount;

  CostEntry(this.resource, this.amount);
}

@MappableClass()
class CostStatic with CostStaticMappable {
  int money;
  List<CostEntry> resourceCosts;

  CostStatic(this.money, this.resourceCosts);
}

class CostComponent extends EyuunComponent<int>{
  static const String propertyName = "cost";

  /// The money cost
  int money = 0;
  /// A list of other resources that are needed to buy this item.
  List<CostEntry> resourceCosts = [];

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }


  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CostStaticMapper.fromMap(staticData);
    resourceCosts = stat.resourceCosts;
    money = stat.money;
  }

  @override
  void reset() {
    money = 0;
    resourceCosts = [];
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // no dynamic data here
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};


}
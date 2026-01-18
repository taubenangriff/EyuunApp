import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

import '../core/EntityExtension.dart';
import '../core/assetLink.dart';

part 'Cost.mapper.dart';

@MappableClass()
class CostEntryStatic with CostEntryMappable {
  /// AssetLink to the resource needed to buy
  AssetLink resource;

  /// The amount of this resource needed
  int amount;

  CostEntryStatic({AssetLink? resource, this.amount = 0})
    : resource = resource ?? AssetLink.invalid();

  static CostEntryStatic from(CostEntry e) {
    return CostEntryStatic(
      resource: e.resource?.asAssetLink(),
      amount: e.amount,
    );
  }
}

class CostEntry {
  Entity? resource;
  int amount;
  CostEntry(this.resource, this.amount);

  static CostEntry fromStatic(CostEntryStatic e) {
    return CostEntry(e.resource.getEntity(), e.amount);
  }
}

@MappableClass()
@reflector
class CostStatic with CostStaticMappable, ComponentReflectable {
  int money;
  List<CostEntryStatic> resourceCosts;

  CostStatic({this.money = 0, List<CostEntryStatic>? resourceCosts})
    : resourceCosts = resourceCosts ?? [];
}

class CostComponent extends EyuunComponent<int> {
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
    resourceCosts = stat.resourceCosts
        .map((e) => CostEntry.fromStatic(e))
        .toList();
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

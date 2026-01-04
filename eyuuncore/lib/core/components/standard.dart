import 'package:eyuuncore/core/reflection/reflector.dart';

import '../reflection/Reflecting.dart';
import 'EyuunComponent.dart';

import 'package:dart_mappable/dart_mappable.dart';

part 'standard.mapper.dart';

@MappableClass()
@reflector
class StandardStatic with StandardStaticMappable, Reflecting {
  final String typeId;
  final String? internalName;
  final String? comment;

  StandardStatic(this.typeId, this.internalName, this.comment);

  static StandardStatic empty() => StandardStatic("notype", "noname", "none");

  static const fromMap = StandardStaticMapper.fromMap;
}

@MappableClass()
class StandardDynamic with StandardDynamicMappable {
  final String objectId;
  final String typeId;

  StandardDynamic(this.objectId, this.typeId);
}

class StandardComponent extends EyuunComponent<String> {
  late String objectId;
  late final String typeId;

  static String propertyName = "standard";

  String? internalName;
  String? comment;

  @override
  void init([String? objectId]) {
    this.objectId = objectId ?? "Noid";
  }

  @override
  void reset() {
    objectId = "";
  }

  @override
  String getName() => propertyName;

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = StandardDynamicMapper.fromMap(dynamicData);
    objectId = dyn.objectId;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = StandardStaticMapper.fromMap(staticData);
    typeId = stat.typeId;
    comment = stat.comment;
    internalName = stat.internalName;
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    var dyn = StandardDynamic(objectId, typeId);
    return dyn.toMap();
  }
}
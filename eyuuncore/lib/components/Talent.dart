import 'package:dart_mappable/dart_mappable.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Talent.mapper.dart';

@MappableClass()
@reflector
class TalentStatic with TalentStaticMappable, ComponentReflectable {
  List<AssetLink> specializations;

  TalentStatic(this.specializations);
}

class TalentComponent extends EyuunComponent<int> {
  static const String propertyName = "talent";

  late List<AssetLink> specializations;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    //nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = TalentStaticMapper.fromMap(staticData);
    specializations = stat.specializations;
  }

  @override
  void reset() {
    specializations = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
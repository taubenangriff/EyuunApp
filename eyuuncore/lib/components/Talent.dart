import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Talent.mapper.dart';

@MappableClass()
@reflector
class TalentStatic with TalentStaticMappable, ComponentReflectable {
  List<AssetLink> specializations;
  TalentGroup skillGroup;

  TalentStatic({
    List<AssetLink>? specializations,
    this.skillGroup = TalentGroup.Basic,
  }) : specializations = specializations ?? [];
}

class TalentComponent extends EyuunComponent<int> {
  static const String propertyName = "talent";

  late List<Entity> specializations;
  late TalentGroup skillGroup;

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
    specializations = stat.specializations.getAssets();
    skillGroup = stat.skillGroup;
  }

  @override
  void reset() {
    specializations = [];
    skillGroup = TalentGroup.Basic;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

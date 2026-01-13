import 'package:dart_mappable/dart_mappable.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Spell.mapper.dart';

@MappableClass()
@reflector
class SpellStatic with SpellStaticMappable, ComponentReflectable {
  int tier;
  AssetLink spellSchool;
  SpellStatic({this.tier = 0, spellSchool}) : spellSchool = spellSchool ?? AssetLink.invalid();
}

class SpellComponent extends EyuunComponent<int> {
  static const String propertyName = "spell";
  int tier = 0;
  late AssetLink spellSchool;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = SpellStaticMapper.fromMap(staticData);
    tier = stat.tier;
    spellSchool = stat.spellSchool;
  }

  @override
  void reset() {
    tier = 0;
    spellSchool = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

import 'package:EyuunApp/enums/CastScope.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'Spell.mapper.dart';

@MappableClass()
class SpellStatic with SpellStaticMappable {
  CastScope castScope;
  int castScopeX;
  int castScopeY;
  int castScopeZ;
  int tier;
  AssetLink spellSchool;

  SpellStatic(this.castScope, this.tier, this.spellSchool,
      [this.castScopeX = 0, this.castScopeY = 0, this.castScopeZ = 0]);
}

class SpellComponent extends EyuunComponent<int> {
  static const String propertyName = "spell";

  /// Cast scope:
  /// self: Cast onto yourself
  /// Sight: Cast in range of your sight
  /// SightRadius: Cast in range of your sight, limited to a maximum of [castScopeX].
  /// Touch: You need to physically touch the target
  /// Aura: Cast a 2D Aura circle with a radius of [castScopeX].
  /// Rectangle: Cast a 2D aura rectangle with dimensions [castScopeX] * [castScopeY].
  /// Cone: Cast a cone shape with radius [castScopeX] which starts at your position.
  /// Cuboid: Cast a cube with dimensions [castScopeX] * [castScopeY] * [castScopeZ].
  /// Variant: The casting scope is so complex that the skills description will tell you.
  late CastScope castScope;
  int castScopeX = 0;
  int castScopeY = 0;
  int castScopeZ = 0;
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

    castScope = stat.castScope;
    castScopeX = stat.castScopeX;
    castScopeY = stat.castScopeY;
    castScopeZ = stat.castScopeZ;
    tier = stat.tier;
    spellSchool = stat.spellSchool;
  }

  @override
  void reset() {
    castScope = CastScope.Self;
    castScopeX = 0;
    castScopeY = 0;
    castScopeZ = 0;
    tier = 0;
    spellSchool = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

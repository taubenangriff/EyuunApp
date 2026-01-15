import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/PersonSize.dart';

import '../core/assetLink.dart';

part 'CharacterBase.mapper.dart';

@MappableClass()
class CharacterBaseDynamic with CharacterBaseDynamicMappable {
  AssetLink upbringing;
  AssetLink childhood;
  List<AssetLink> visualUpbringings;
  int level;
  String origin;
  PersonSize personSize;

  CharacterBaseDynamic({
    AssetLink? upbringing,
    AssetLink? childhood,
    this.level = 0,
    this.origin = "",
    this.personSize = PersonSize.Normal,
    List<AssetLink>? visualUpbringings,
  }) : upbringing = upbringing ?? AssetLink.invalid(),
       visualUpbringings = visualUpbringings ?? [],
       childhood = childhood ?? AssetLink.invalid();
}

@MappableClass()
@reflector
class CharacterBaseStatic
    with CharacterBaseStaticMappable, ComponentReflectable {
  CharacterBaseStatic();
}

class CharacterBaseComponent extends EyuunComponent<int> {
  static const String propertyName = "characterBase";

  late AssetLink upbringing;
  late List<AssetLink> visualUpbringings;
  late AssetLink childhood;
  late int level;
  late String origin;

  /// the visual size of this person. To get their speed, refer to [CombatComponent.speed].
  late PersonSize personSize;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = CharacterBaseDynamicMapper.fromMap(dynamicData);
    upbringing = dyn.upbringing;
    visualUpbringings = dyn.visualUpbringings;
    childhood = dyn.childhood;
    level = dyn.level;
    origin = dyn.origin;
    personSize = dyn.personSize;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {}

  bool hasSecondaryUpbringing() => visualUpbringings.isEmpty;

  @override
  void reset() {
    upbringing = AssetLink.invalid();
    visualUpbringings = [];
    childhood = AssetLink.invalid();
    level = 0;
    origin = "";
    personSize = PersonSize.Normal;
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterBaseDynamic(
    upbringing: upbringing,
    childhood: childhood,
    level: level,
    origin: origin,
    visualUpbringings: visualUpbringings,
    personSize: personSize
  ).toMap();
}

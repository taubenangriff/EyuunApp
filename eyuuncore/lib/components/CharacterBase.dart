import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:eyuuncore/enums/PersonSize.dart';
import 'package:oxygen/oxygen.dart';

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
  CharacterState characterState;

  Uri? image;

  CharacterBaseDynamic({
    AssetLink? upbringing,
    AssetLink? childhood,
    this.characterState = CharacterState.InCreation,
    this.level = 0,
    this.origin = "",
    this.personSize = PersonSize.Normal,
    List<AssetLink>? visualUpbringings,
    this.image,
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

  late Entity? upbringing;
  late List<Entity> visualUpbringings;
  late Entity? childhood;
  late int level;
  late String origin;
  Uri? image;
  late CharacterState characterState;

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
    upbringing = dyn.upbringing.getEntity();
    visualUpbringings = dyn.visualUpbringings.getAssets();
    childhood = dyn.childhood.getEntity();
    level = dyn.level;
    origin = dyn.origin;
    personSize = dyn.personSize;
    image = dyn.image;
    characterState = dyn.characterState;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {}

  bool hasSecondaryUpbringing() => visualUpbringings.isEmpty;

  @override
  void reset() {
    upbringing = null;
    visualUpbringings = [];
    childhood = null;
    level = 0;
    origin = "";
    personSize = PersonSize.Normal;
    image = null;
    characterState = CharacterState.InCreation;
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterBaseDynamic(
    upbringing: upbringing?.asAssetLink(),
    childhood: childhood?.asAssetLink(),
    level: level,
    origin: origin,
    visualUpbringings: visualUpbringings.asAssetLinks(),
    personSize: personSize,
    image: image,
    characterState: characterState,
  ).toMap();
}

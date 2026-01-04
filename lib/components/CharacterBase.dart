import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'CharacterBase.mapper.dart';

@MappableClass()
class CharacterBaseDynamic with CharacterBaseDynamicMappable {
  AssetLink upbringing;
  AssetLink childhood;
  AssetLink? secondUpbringing;
  int level;
  String origin;

  CharacterBaseDynamic(this.upbringing, this.childhood, this.level, this.origin, {this.secondUpbringing});
}

@MappableClass()
class CharacterBaseStatic with CharacterBaseStaticMappable {
  CharacterBaseStatic();
}

class CharacterBaseComponent extends EyuunComponent<int> {
  static const String propertyName = "characterBase";

  late AssetLink upbringing;
  AssetLink? secondUpbringing;
  late AssetLink childhood;
  late int level;
  late String origin;

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
    secondUpbringing = dyn.secondUpbringing;
    childhood = dyn.childhood;
    level = dyn.level;
    origin = dyn.origin;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {

  }

  bool hasSecondaryUpbringing() => secondUpbringing != null;

  @override
  void reset() {
    upbringing = AssetLink.invalid();
    secondUpbringing = null;
    childhood = AssetLink.invalid();
    level = 0;
    origin = "";
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterBaseDynamic(upbringing, childhood, level, origin, secondUpbringing: secondUpbringing).toMap();
}
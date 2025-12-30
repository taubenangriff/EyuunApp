import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'CharacterBase.mapper.dart';

@MappableClass()
class CharacterBaseDynamic with CharacterBaseDynamicMappable {
  AssetLink upbringing;
  AssetLink childhood;
  int level;
  AssetLink origin;

  CharacterBaseDynamic(this.upbringing, this.childhood, this.level, this.origin);
}

@MappableClass()
class CharacterBaseStatic with CharacterBaseStaticMappable {
  CharacterBaseStatic();
}

class CharacterBaseComponent extends EyuunComponent<int> {
  static const String propertyName = "characterBase";

  late AssetLink upbringing;
  late AssetLink childhood;
  late int level;
  late AssetLink origin;

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
    childhood = dyn.childhood;
    level = dyn.level;
    origin = dyn.origin;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CharacterBaseStaticMapper.fromMap(staticData);
  }

  @override
  void reset() {

  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterBaseDynamic(upbringing, childhood, level, origin).toMap();
}
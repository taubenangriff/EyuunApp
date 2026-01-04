import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/assetLink.dart';

part 'CharacterTables.mapper.dart';

@MappableClass()
class CharacterTablesStatic with CharacterTablesStaticMappable {
  AssetLink languages;
  CharacterTablesStatic(this.languages);
}

class CharacterTablesFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "characterTablesFeature";

  /// link to the Asset with [AssetBundleComponent] that contains all the language assets.
  late AssetLink languages;

  List<Entity> getLanguages() => languages.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];

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
    var stat = CharacterTablesStaticMapper.fromMap(staticData);
    languages = stat.languages;
  }

  @override
  void reset() {
    languages = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
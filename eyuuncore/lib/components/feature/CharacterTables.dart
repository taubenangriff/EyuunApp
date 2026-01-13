import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/assetLink.dart';

part 'CharacterTables.mapper.dart';

@MappableClass()
@reflector
class CharacterTablesFeatureStatic
    with CharacterTablesFeatureStaticMappable, ComponentReflectable {
  AssetLink languages;
  AssetLink childhoods;
  AssetLink upbringings;
  AssetLink spells;
  AssetLink tricks;

  CharacterTablesFeatureStatic({
    AssetLink? languages,
    AssetLink? childhoods,
    AssetLink? upbringings,
    AssetLink? spells,
    AssetLink? tricks,
  }) : languages = languages ?? AssetLink.invalid(),
       childhoods = childhoods ?? AssetLink.invalid(),
       upbringings = upbringings ?? AssetLink.invalid(),
       spells = spells ?? AssetLink.invalid(),
       tricks = tricks ?? AssetLink.invalid();
}

class CharacterTablesFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "characterTablesFeature";

  /// link to the Asset with [AssetBundleComponent] that contains all the language assets.
  late AssetLink _languages;
  late AssetLink _childhoods;
  late AssetLink _upbringings;
  late AssetLink _spells;
  late AssetLink _tricks;

  List<Entity> get languages =>
      _languages.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get childhoods =>
      _childhoods.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get upbringings =>
      _upbringings.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get spells =>
      _spells.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get tricks =>
      _tricks.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];

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
    var stat = CharacterTablesFeatureStaticMapper.fromMap(staticData);
    _languages = stat.languages;
    _childhoods = stat.childhoods;
    _upbringings = stat.upbringings;
    _tricks = stat.tricks;
    _spells = stat.spells;
  }

  @override
  void reset() {
    _languages = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

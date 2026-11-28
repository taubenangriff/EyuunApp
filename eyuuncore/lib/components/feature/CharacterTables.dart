import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/PersonSize.dart';
import 'package:eyuuncore/io/EnumMapper.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/assetLink.dart';

part 'CharacterTables.mapper.dart';

@MappableClass(includeCustomMappers: [PersonSizeIntMapper()])
@reflector
class CharacterTablesFeatureStatic
    with CharacterTablesFeatureStaticMappable, ComponentReflectable {
  AssetLink languages;
  AssetLink childhoods;
  AssetLink upbringings;
  AssetLink secondaryUpbringings;
  AssetLink spells;
  AssetLink tricks;

  Map<PersonSize, int> speedBySize;

  /// Flat hitpoints every character starts with, before attribute impacts.
  int baseHealth;

  /// Flat inventory slots every character starts with, before attribute impacts.
  int baseInventoryCapacity;

  CharacterTablesFeatureStatic({
    AssetLink? languages,
    AssetLink? childhoods,
    AssetLink? upbringings,
    AssetLink? secondaryUpbringings,
    AssetLink? spells,
    AssetLink? tricks,
    Map<PersonSize, int>? speedBySize,
    this.baseHealth = 15,
    this.baseInventoryCapacity = 2,
  }) : languages = languages ?? AssetLink.invalid(),
       childhoods = childhoods ?? AssetLink.invalid(),
       upbringings = upbringings ?? AssetLink.invalid(),
       secondaryUpbringings = secondaryUpbringings ?? AssetLink.invalid(),
       spells = spells ?? AssetLink.invalid(),
       tricks = tricks ?? AssetLink.invalid(),
       speedBySize = speedBySize ?? {};
}

class CharacterTablesFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "characterTablesFeature";

  /// link to the Asset with [AssetBundleComponent] that contains all the language assets.
  late Entity? _languages;
  late Entity? _childhoods;
  late Entity? _upbringings;
  late Entity? _secondaryUpbringings;
  late Entity? _spells;
  late Entity? _tricks;
  late Map<PersonSize, int> _speedBySize;
  late int _baseHealth;
  late int _baseInventoryCapacity;

  int get baseHealth => _baseHealth;
  int get baseInventoryCapacity => _baseInventoryCapacity;

  List<Entity> get languages =>
      _languages?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get childhoods =>
      _childhoods?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get upbringings =>
      _upbringings?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get secondaryUpbringings =>
      _secondaryUpbringings?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get spells =>
      _spells?.get<AssetBundleComponent>()?.getAssets() ?? [];
  List<Entity> get tricks =>
      _tricks?.get<AssetBundleComponent>()?.getAssets() ?? [];

  int getSpeed(PersonSize size) {
    if (_speedBySize.containsKey(size)) {
      return _speedBySize[size]!;
    }
    return _speedBySize[PersonSize.Normal] ?? 0;
  }

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
    _languages = stat.languages.getEntity();
    _childhoods = stat.childhoods.getEntity();
    _upbringings = stat.upbringings.getEntity();
    _secondaryUpbringings = stat.secondaryUpbringings.getEntity();
    _tricks = stat.tricks.getEntity();
    _spells = stat.spells.getEntity();
    _speedBySize = stat.speedBySize;
    _baseHealth = stat.baseHealth;
    _baseInventoryCapacity = stat.baseInventoryCapacity;
  }

  @override
  void reset() {
    _languages = null;
    _childhoods = null;
    _upbringings = null;
    _secondaryUpbringings = null;
    _tricks = null;
    _spells = null;
    _speedBySize = {};
    _baseHealth = 15;
    _baseInventoryCapacity = 2;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

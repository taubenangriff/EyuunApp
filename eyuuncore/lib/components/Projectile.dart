import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/assetLink.dart';

part 'Projectile.mapper.dart';

@MappableClass()
@reflector
class ProjectileStatic with ProjectileStaticMappable, ComponentReflectable {
  AssetLink? effectOnHit;

  ProjectileStatic({this.effectOnHit});
}

class ProjectileComponent extends EyuunComponent<int> {
  static const String propertyName = "projectile";

  late AssetLink? effectOnHit;

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
    var stat = ProjectileStaticMapper.fromMap(staticData);
    effectOnHit = stat.effectOnHit;
  }

  @override
  void reset() {
    effectOnHit = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'Projectile.mapper.dart';

@MappableClass()
class ProjectileStatic with ProjectileStaticMappable {
  AssetLink effectOnHit;

  ProjectileStatic(this.effectOnHit);
}

class ProjectileComponent extends EyuunComponent<int> {
  static const String propertyName = "projectile";

  late AssetLink effectOnHit;

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
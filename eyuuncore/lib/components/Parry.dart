import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/enums/FightingType.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Parry.mapper.dart';

@MappableClass()
@reflector
class ParryStatic with ParryStaticMappable, ComponentReflectable {
  List<AttackScope> parriableAttackScopes;
  AssetLink? parryTalent;
  bool useMaxSkillInsteadOfTalent;
  ParryStatic({
    List<AttackScope>? parriableAttackScopes,
    this.useMaxSkillInsteadOfTalent = false,
    this.parryTalent,
  }) : parriableAttackScopes = parriableAttackScopes ?? [];
}

class ParryComponent extends EyuunComponent<int> {
  static const String propertyName = "parry";

  late List<AttackScope> parriableAttackScopes;
  late bool useMaxSkillInsteadOfTalent;
  late AssetLink? parryTalent;

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
    var stat = ParryStaticMapper.fromMap(staticData);
    parriableAttackScopes = stat.parriableAttackScopes;
    useMaxSkillInsteadOfTalent = stat.useMaxSkillInsteadOfTalent;
    parryTalent = stat.parryTalent;
  }

  @override
  void reset() {}

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}

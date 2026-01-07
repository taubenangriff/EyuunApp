import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

import '../components/Weapon.dart';

class SkillcheckController {
  SkillLearnerComponent skillLearner;
  AttributesComponent attributes;

  SkillcheckController(this.skillLearner, this.attributes);

  int getWeaponSkill(Entity weapon){
    var weaponComp = weapon.get<WeaponComponent>();
    var fightingTypeId = weaponComp?.fightingType.id;
    var skillMultiplier = weaponComp?.skillMultiplier ?? 0;

    num skillValue = fightingTypeId != null ? skillLearner.getSkillValue(fightingTypeId) : 0;
    skillValue *= skillMultiplier;
    return skillValue.round();
  }
}
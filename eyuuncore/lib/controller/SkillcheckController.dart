import 'dart:math';

import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Talent.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

import '../components/Weapon.dart';

class SkillcheckController {
  SkillLearnerComponent skillLearner;

  SkillcheckController(this.skillLearner);

  int getSkill(Entity entity){
    if(entity.has<WeaponComponent>()) {
      return getWeaponSkill(entity);
    }
    if(entity.has<SkillcheckComponent>()){
      return getActiveTalentSkill(entity);
    }
    return 0;
  }

  int getWeaponSkill(Entity weapon){
    var weaponComp = weapon.get<WeaponComponent>();
    var fightingTypeId = weaponComp?.fightingType?.getTypeId();
    var skillMultiplier = weaponComp?.skillMultiplier ?? 0;

    num skillValue = fightingTypeId != null ? skillLearner.getSkillValue(fightingTypeId) : 0;
    skillValue *= skillMultiplier;
    return skillValue.round();
  }

  int getActiveTalentSkill(Entity talentEntity){
    var skillcheck = talentEntity.get<SkillcheckComponent>();
    var id = skillcheck?.overrideSkillcheck?.getTypeId() ?? talentEntity.getTypeId();
    return skillLearner.getSkillValue(id);
  }
}
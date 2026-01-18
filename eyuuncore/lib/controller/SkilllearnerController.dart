import 'dart:math';

import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

class SkillLearnerController {
  final SkillLearnerComponent skillLearner;
  final bool allowDowngrades;

  const SkillLearnerController({required this.skillLearner, this.allowDowngrades = false});

  int getMax(){
    var spent = skillLearner.getSpentSkillpoints();
    var cap = skillLearner.skillCeiling.current;
    return min(cap, skillLearner.skillpoints.current - spent);
  }

  int getMin(Entity? skillEntity) {
    if(allowDowngrades){
      return 0;
    }
    if(skillEntity == null){
      return 0;
    }
    return skillLearner.getSkillValue(skillEntity.getTypeId());
  }

  bool canSkill() {
    if(allowDowngrades) {
      return true;
    }
    return skillLearner.getSpentSkillpoints() < skillLearner.skillpoints.current;
  }

  void setSkillvalue(Entity? skillEntity, int value){
    if(skillEntity == null){
      return;
    }
    skillLearner.setSkillValue(skillEntity.getTypeId(), value);
  }
}
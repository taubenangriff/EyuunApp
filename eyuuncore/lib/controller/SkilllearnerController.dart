import 'dart:math';

import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

class SkillLearnerController {
  final SkillLearnerComponent skillLearner;

  const SkillLearnerController({required this.skillLearner});

  int getMax(){
    var spent = skillLearner.getSpentSkillpoints();
    var cap = skillLearner.skillCeiling.current;
    return min(cap, skillLearner.skillpoints.current - spent);
  }

  bool canSkill() {
    return skillLearner.getSpentSkillpoints() < skillLearner.skillpoints.current;
  }

  void addSkillvalue(Entity? skillEntity, int value){
    if(skillEntity == null){
      return;
    }
    var prev = skillLearner.getSkillValue(skillEntity.getTypeId());
    skillLearner.setSkillValue(skillEntity.getTypeId(), prev+value);
  }
}
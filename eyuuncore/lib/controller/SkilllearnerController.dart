import 'dart:math';

import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:oxygen/oxygen.dart';

import '../GetIt.dart';

class SkillLearnerController {
  final SkillLearnerComponent skillLearner;
  final bool allowDowngrades;
  late final worldManager = locator<WorldManager>();

  SkillLearnerController({required this.skillLearner, this.allowDowngrades = false});

  int getMax(Entity skillEntity){
    var spent = skillLearner.getSpentSkillpoints();
    var cap = skillLearner.skillCeiling.current;
    var currentlySkilled = skillLearner.getSkillValue(skillEntity.getTypeId());
    return max(min(cap, skillLearner.skillpoints.current - spent), currentlySkilled);
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

  bool canSkill(Entity? skillEntity) {
    if(skillEntity == null){
      return false;
    }
    if(allowDowngrades && skillLearner.getSkillValue(skillEntity.getTypeId()) > 0){
      return true;
    }
    return skillLearner.getSpentSkillpoints() < skillLearner.skillpoints.current;
  }

  // TODO protect against picking tricks that aren't allowed to be picked
  void pickTrick(Entity trick) {
    skillLearner.tricks.add(trick);
    worldManager.execute();
  }

  // TODO protect against picking skills that aren't allowed to be picked
  void pickSpell(Entity spell) {
    skillLearner.spells.add(spell);
    worldManager.execute();
  }

  // TODO filter the list
  List<Entity> getAvailableSpells() => locator<CharacterTablesFeatureComponent>().spells;

  // TODO filter the list
  List<Entity> getAvailableTricks() => locator<CharacterTablesFeatureComponent>().tricks;

  void setSkillvalue(Entity? skillEntity, int value){
    if(skillEntity == null){
      return;
    }
    skillLearner.setSkillValue(skillEntity.getTypeId(), value);
  }
}
import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:flutter/material.dart';

import '../StatItem.dart';

class CombatStatsRow extends StatelessWidget {
  final CombatComponent combat;
  final SkillLearnerComponent skillLearner;
  late final SkillcheckController controller =
      SkillcheckController(skillLearner);

  CombatStatsRow({super.key, required this.combat, required this.skillLearner});

  @override
  Widget build(BuildContext context) {
    var combatMelee =
        locator<GameObjectService>().getStatic("fightingstyle_melee");
    var combatRange =
        locator<GameObjectService>().getStatic("fightingstyle_range");

    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Combat Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 64,
          runSpacing: 32,
          children: [
            StatItem(
              icon: Icons.directions_run,
              label: 'Speed',
              value: combat.speed.current,
            ),
            StatItem(
              icon: Icons.shield_outlined,
              label: 'Evasion',
              value: combat.evasion.current,
            ),
            StatItem(
              icon: Icons.flash_on,
              label: 'Initiative',
              value: combat.initiative.current,
            ),
            if (combatMelee != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Melee attack',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  EyuunWidgets.spacerHorizontal(),
                  EyuunWidgets.circularFloatingActionButton(
                      radius: 32,
                      text: "${controller.getActiveTalentSkill(combatMelee)}")
                ],
              ),
            if (combatRange != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Range attack',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  EyuunWidgets.spacerHorizontal(),
                  EyuunWidgets.circularFloatingActionButton(
                      radius: 32,
                      text: "${controller.getActiveTalentSkill(combatRange)}")
                ],
              )
          ],
        )
      ],
    ));
  }
}

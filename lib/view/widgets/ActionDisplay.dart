import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ActionDisplay extends StatelessWidget {
  final Entity action;
  final Entity? source;
  const ActionDisplay({super.key, required this.action, this.source});

  @override
  Widget build(BuildContext context) {
    var textService = locator<TextService>();
    var actionComponent = action.get<ActionComponent>();

    var attributes =
        locator<CharacterService>().character.get<AttributesComponent>();
    var skillLearner =
        locator<CharacterService>().character.get<SkillLearnerComponent>();

    return LayoutBuilder(builder: (context, constraints) {
      var enaughWidth = constraints.maxWidth > 240;
      var theme = Theme.of(context);

      return Column(
          children: [
        Text(
            "${textService.getTextFromEntity(action)}${source != action && source != null ? " (${textService.getTextFromEntity(source)})" : ""}",
            style: theme.textTheme.titleLarge),
        if (actionComponent != null) ...{
          Text(textService.getText(actionComponent.actionTime.getTextKey())),
          EyuunWidgets.spacerVertical(),
          Text(textService.getActionDescriptionFromEntity(action),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.fade),
          EyuunWidgets.spacerVertical(),
          if(actionComponent.fluxCost > 0)... {
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water, size: 32),
                SizedBox(width: 6),
                Text('!Flux: ${actionComponent.fluxCost}${(actionComponent.billingCycle != BillingCycle.Once) ? "/${actionComponent.billingCycle.toString()}" : ""}', style: theme.textTheme.headlineSmall,),
              ],
            ),
          }
        },

        // 🎲 Skill check widget
        if (action.has<SkillcheckComponent>() &&
            attributes != null &&
            skillLearner != null) ...{
          EyuunWidgets.spacerVertical(),
          Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SkillCheckWidget(
                skillcheck: action.get<SkillcheckComponent>()!,
                attributes: attributes,
                spacing: 2,
                showText: false,
                iconSize: enaughWidth ? 46 : 38),
            Text(
                " + ${SkillcheckController(skillLearner).getActiveTalentSkill(action)}",
                style: enaughWidth
                    ? theme.textTheme.headlineMedium
                    : theme.textTheme.bodyLarge)
          ])),
        },
        EyuunWidgets.spacerVertical(),
      ]);
    });
  }
}

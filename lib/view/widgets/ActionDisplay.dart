import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Spell.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

enum TextBehavior { scroll, fade }

class ActionDisplay extends StatelessWidget {
  final Entity action;
  final Entity? source;
  final TextBehavior textBehavior;
  const ActionDisplay(
      {super.key,
      required this.action,
      this.source,
      this.textBehavior = TextBehavior.scroll});

  @override
  Widget build(BuildContext context) {
    var textService = locator<TextService>();
    var actionComponent = action.get<ActionComponent>();

    var attributes =
        locator<CharacterService>().character.get<AttributesComponent>();
    var skillLearner =
        locator<CharacterService>().character.get<SkillLearnerComponent>();

    return LayoutBuilder(builder: (context, constraints) {
      var enaughWidth = constraints.maxWidth > 200;
      var theme = Theme.of(context);

      return Column(children: [
        Text(
            textAlign: TextAlign.center,
            "${textService.getTextFromEntity(action)}${source != action && source != null ? " (${textService.getTextFromEntity(source)})" : ""}",
            style: theme.textTheme.titleLarge),
        if (actionComponent != null) ...{
          Text(textService.getText(actionComponent.actionTime.getTextKey())),
          SizedBox(height: 8),
          if (textBehavior == TextBehavior.fade)
            Expanded(
                child: Text(
              textService.getActionDescriptionFromEntity(action),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.fade,
            )),
          if (textBehavior == TextBehavior.scroll)
            Expanded(
                child: SingleChildScrollView(
                    child: Text(
                        textAlign: TextAlign.justify,
                        textService.getActionDescriptionFromEntity(action)))),
          SizedBox(height: 8),
          if (actionComponent.fluxCost > 0) ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water, size: 24),
                SizedBox(width: 6),
                Text(
                  '!Flux: ${actionComponent.fluxCost}${(actionComponent.billingCycle != BillingCycle.Once) ? "/!round" : ""}',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          },
        },
        if (action.has<SpellComponent>()) ...{
          SizedBox(height: 8),
          Text(
              "School: ${textService.getTextFromEntity(action.get<SpellComponent>()!.spellSchool)}")
        },
        if (action.has<SkillcheckComponent>() &&
            attributes != null &&
            skillLearner != null) ...{
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SkillCheckWidget(
                skillcheck: action.get<SkillcheckComponent>()!,
                attributes: attributes,
                spacing: 2,
                showText: false,
                iconSize: enaughWidth ? 46 : 38),
            Text(" + ${SkillcheckController(skillLearner).getSkill(action)}",
                style: enaughWidth
                    ? theme.textTheme.headlineMedium
                    : theme.textTheme.bodyLarge)
          ])
        },
      ]);
    });
  }
}

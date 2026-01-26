import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Casted.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Spell.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';
import 'package:eyuuncore/enums/CastScope.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

enum TextBehavior { scroll, fade }

class ActionDisplay extends StatelessWidget {
  final Entity action;
  final Entity? source;
  bool showCost;
  final TextBehavior textBehavior;
  ActionDisplay(
      {super.key,
      required this.action,
      this.showCost = true,
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
        if(actionComponent != null)... {
          Text(textService.getText(actionComponent.actionTime.getTextKey())),
        },
        SizedBox(height: 8),
        Text(
            textAlign: TextAlign.center,
            "${textService.getTextFromEntity(action)}${source != action && source != null ? " (${textService.getTextFromEntity(source)})" : ""}",
            style: theme.textTheme.titleLarge),
        if (actionComponent != null) ...{
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
        },
        if (action.has<CastedComponent>()) ...{
          Text(textService.getText('uitext_casted_scope', formatArgs: [
            textService.getText(
                action.get<CastedComponent>()!.castScope.getTextKey(),
                formatArgs: [
                  action.get<CastedComponent>()!.castScopeX.toString(),
                  action.get<CastedComponent>()!.castScopeY.toString(),
                  action.get<CastedComponent>()!.castScopeZ.toString(),
                ]).toString()
          ]))
        },
        if (action.has<SpellComponent>()) ...{
          Text(textService.getText('uitext_action_spellschool', formatArgs: [
            textService.getTextFromEntity(action.get<SpellComponent>()!.spellSchool)
          ]))
        },
        if (showCost &&
            actionComponent != null &&
            actionComponent.fluxCost > 0) ...{
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water, size: 24),
              SizedBox(width: 6),
              Text(textService.getText(
                  switch (actionComponent.billingCycle) {
                    BillingCycle.Once => 'uitext_flux_once',
                    BillingCycle.PerRound => 'uitext_flux_per_round',
                    BillingCycle.PerHour => 'uitext_flux_per_hour',
                  },
                  formatArgs: [actionComponent.fluxCost.toString()])),
            ],
          ),
          SizedBox(height: 8),
        },
        if (action.has<SkillcheckComponent>() &&
            attributes != null &&
            skillLearner != null) ...{
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

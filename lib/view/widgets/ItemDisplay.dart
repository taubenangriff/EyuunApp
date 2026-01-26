import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Craftable.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ItemDisplay extends StatelessWidget {
  final Entity item;
  const ItemDisplay({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var textService = locator<TextService>();

    var craftable = item.get<CraftableComponent>();
    var weapon = item.get<WeaponComponent>();
    var actionUser = item.get<ActionUserComponent>();
    var armor = item.get<ArmorComponent>();

    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${textService.getFluffFromEntity(item)}"),
        if (weapon != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: textService.getText('uitext_weapon', formatArgs: [
              textService.getTextFromEntity(weapon.fightingType)
            ])),
            TextSpan(text: textService.getText('uitext_weapon_explainer')),
          ], style: theme.textTheme.bodyMedium))
        },
        if (craftable != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: textService.getText('uitext_craftable')),
            TextSpan(text: textService.getText('uitext_craftable_explainer')),
          ], style: theme.textTheme.bodyMedium)),
          if (craftable.craftMethod != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: textService.getText('uitext_craftmethod')),
              TextSpan(
                  text: textService.getTextFromEntity(craftable.craftMethod!)),
            ])),
          if (craftable.material != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: textService.getText('uitext_material')),
              TextSpan(
                  text: textService.getTextFromEntity(craftable.material!)),
            ])),
          for (var upgrade in craftable.upgrades)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: textService.getText('uitext_upgrade')),
              TextSpan(text: textService.getTextFromEntity(upgrade)),
            ]))
        },
        if (actionUser != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: textService.getText('uitext_actions')),
            TextSpan(text: textService.getText('uitext_actions_explainer')),
          ], style: theme.textTheme.bodyMedium)),
          for (var action in actionUser.getActions())
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: textService.getTextFromEntity(action) + ": "),
              TextSpan(
                  text: textService.getActionDescriptionFromEntity(action)),
            ], style: theme.textTheme.bodyMedium))
        },
        if (armor != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: textService.getText('uitext_armor_toughness',
                    formatArgs: [armor.armorToughness.current.toString()])),
          ], style: theme.textTheme.bodyMedium)),
          if (armor.isTemplate)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: textService.getText('uitext_armor_impactOnCraft')),
              if (armor.stealthImpactOnCraft > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact',
                        formatArgs: [
                      armor.stealthImpactOnCraft.toString(),
                      textService.getText('talent_sneaky')
                    ])),
              if (armor.evasionImpactOnCraft > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact',
                        formatArgs: [
                          armor.evasionImpactOnCraft.toString(),
                          textService.getText('uitext_evasion')
                        ])),
              if (armor.athleticImpactOnCraft > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact',
                        formatArgs: [
                          armor.evasionImpactOnCraft.toString(),
                          textService.getText('talent_athletic')
                        ])),
              if (armor.splittableImpactOnCraft > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact_distributable',
                        formatArgs: [
                          armor.splittableImpactOnCraft.toString()
                        ])),
            ], style: theme.textTheme.bodyMedium)),
          if (!armor.isTemplate)
            RichText(
                text: TextSpan(children: [
                  TextSpan(text: textService.getText('uitext_armor_impactOnCraft')),
              if (armor.stealthImpact > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact',
                        formatArgs: [
                          armor.stealthImpact.toString(),
                          textService.getText('talent_sneaky')
                        ])),
              if (armor.evasionImpact > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact',
                        formatArgs: [
                          armor.evasionImpact.toString(),
                          textService.getText('uitext_evasion')
                        ])),
              if (armor.athleticImpact > 0)
                TextSpan(
                    text: textService.getText('uitext_armor_impact',
                        formatArgs: [
                          armor.athleticImpact.toString(),
                          textService.getText('talent_athletic')
                        ])),
            ], style: theme.textTheme.bodyMedium)),
        }
      ]);
    });
  }
}

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
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

    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${textService.getFluffFromEntity(item)}"),
        if (weapon != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text:
                    '!Weapon (${textService.getTextFromEntity(weapon.fightingType)}): '),
            TextSpan(text: 'This item can be used to attack other characters'),
          ], style: theme.textTheme.bodyMedium))
        },
        if (craftable != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: '!Craftable: '),
            TextSpan(text: 'This item can be modified on the crafting table'),
          ], style: theme.textTheme.bodyMedium)),
          if (craftable.craftMethod != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: '!Craft Method:'),
              TextSpan(
                  text: textService.getTextFromEntity(craftable.craftMethod!)),
            ])),
          if (craftable.material != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: '!Material:'),
              TextSpan(
                  text: textService.getTextFromEntity(craftable.material!)),
            ])),
          for (var upgrade in craftable.upgrades)
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: '!Upgrade:'),
              TextSpan(text: textService.getTextFromEntity(upgrade)),
            ]))
        },
        if (actionUser != null) ...{
          EyuunWidgets.spacerVertical(),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: '!Actions:'),
            TextSpan(text: 'This item adds the following actions:'),
          ], style: theme.textTheme.bodyMedium)),
          for (var action in actionUser.getActions())
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "- "),
              TextSpan(text: textService.getTextFromEntity(action) + ": "),
              TextSpan(
                  text: textService.getActionDescriptionFromEntity(action)),
            ], style: theme.textTheme.bodyMedium))
        }
      ]);
    });
  }
}

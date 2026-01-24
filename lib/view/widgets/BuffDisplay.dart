import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/upgrade/ActionUserUpgrade.dart';
import 'package:eyuuncore/components/upgrade/ArmorUpgrade.dart';
import 'package:eyuuncore/components/upgrade/AttributesUpgrade.dart';
import 'package:eyuuncore/components/upgrade/Buff.dart';
import 'package:eyuuncore/components/upgrade/CharacterPathUpgrade.dart';
import 'package:eyuuncore/components/upgrade/CombatUpgrade.dart';
import 'package:eyuuncore/components/upgrade/FluxUpgrade.dart';
import 'package:eyuuncore/components/upgrade/HealthUpgrade.dart';
import 'package:eyuuncore/components/upgrade/LanguageLearnerUpgrade.dart';
import 'package:eyuuncore/components/upgrade/TalentsUpgrade.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class BuffDisplay extends StatelessWidget {
  final Entity? buff;

  const BuffDisplay({super.key, required this.buff});

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildContent(context));
  }

  List<Widget> _buildContent(BuildContext context) {
    List<Widget> widgets = [];
    if (buff == null) {
      return widgets;
    }

    if (buff!.has<BuffComponent>()) {
      var key = buff!.get<BuffComponent>()!.textDescription;
      if (key != "") {
        var desctext = locator<TextService>().getText(key);
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(desctext)));
      }
    }

    if (buff!.has<FluxUpgradeComponent>()) {
      if (widgets.isNotEmpty) {
        _addDivider(widgets);
      }

      var fluxUpgrade = buff!.get<FluxUpgradeComponent>()!;
      if (fluxUpgrade.fluxCapacityUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.air,
            "uitext_fluxcapacityupgrade",
            fluxUpgrade.fluxCapacityUpgrade.toString()));
      }
      if (fluxUpgrade.fluxMaximumUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.air,
            "uitext_fluxmaximumupgrade",
            fluxUpgrade.fluxMaximumUpgrade.toString()));
      }
    }

    if (buff!.has<ArmorUpgradeComponent>()) {
      var armorUpgrade = buff!.get<ArmorUpgradeComponent>()!;
      if (armorUpgrade.armorToughnessBonus > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.shield,
            "uitext_armortoughnessupgrade",
            armorUpgrade.armorToughnessBonus.toString()));
      }
    }

    if (buff!.has<AttributesUpgradeComponent>()) {
      var attributesUpgrade = buff!.get<AttributesUpgradeComponent>()!;
      if (attributesUpgrade.maxDiceIncreasesUpgrade > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.lunch_dining_outlined,
            "uitext_attributediceupgrade",
            attributesUpgrade.maxDiceIncreasesUpgrade.toString()));
      }
    }

    if (buff!.has<CharacterPathUpgradeComponent>()) {
      var characterPathUpgrade = buff!.get<CharacterPathUpgradeComponent>()!;
      if (characterPathUpgrade.pathCapacityUpgrade > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.lunch_dining_outlined,
            "uitext_pathupgrade",
            characterPathUpgrade.pathCapacityUpgrade.toString()));
      }
    }

    if (buff!.has<CombatUpgradeComponent>()) {
      var combatUpgrade = buff!.get<CombatUpgradeComponent>()!;

      if (combatUpgrade.speedUpgrade > 0 ||
          combatUpgrade.evasionUpgrade > 0 ||
          combatUpgrade.initiativeUpgrade > 0 ||
          combatUpgrade.actionsPerRoundUpgrade > 0 ||
          combatUpgrade.reactionsPerRoundUpgrade > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
      }

      if (combatUpgrade.speedUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(context, Icons.speed,
            "uitext_speedupgrade", combatUpgrade.speedUpgrade.toString()));
      }
      if (combatUpgrade.evasionUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(context, Icons.agriculture,
            "uitext_evasionupgrade", combatUpgrade.evasionUpgrade.toString()));
      }
      if (combatUpgrade.initiativeUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.agriculture,
            "uitext_initiativeupgrade",
            combatUpgrade.initiativeUpgrade.toString()));
      }
      if (combatUpgrade.actionsPerRoundUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.call_to_action_outlined,
            "uitext_actionsupgrade",
            combatUpgrade.actionsPerRoundUpgrade.toString()));
      }
      if (combatUpgrade.reactionsPerRoundUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.call_to_action_outlined,
            "uitext_reactionsupgrade",
            combatUpgrade.reactionsPerRoundUpgrade.toString()));
      }
    }

    if (buff!.has<HealthUpgradeComponent>()) {
      var healthUpgrade = buff!.get<HealthUpgradeComponent>()!;

      if (healthUpgrade.maxHitpointsUpgrade > 0 ||
          healthUpgrade.maxDeathThrowsUpgrade > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
      }

      if (healthUpgrade.maxHitpointsUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.health_and_safety,
            "uitext_maxhealthupgrade",
            healthUpgrade.maxHitpointsUpgrade.toString()));
      }
      if (healthUpgrade.maxDeathThrowsUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.health_and_safety,
            "uitext_maxdtupgrade",
            healthUpgrade.maxDeathThrowsUpgrade.toString()));
      }
    }

    if (buff!.has<LanguageLearnerUpgradeComponent>()) {
      var llUpgrade = buff!.get<LanguageLearnerUpgradeComponent>()!;

      if (llUpgrade.languageMaxPotentialUpgrade > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.speaker_notes,
            "uitext_langpotentialupgrade",
            llUpgrade.languageMaxPotentialUpgrade.toString()));
      }
    }

    if (buff!.has<TalentsUpgradeComponent>()) {
      var talentsUpgrade = buff!.get<TalentsUpgradeComponent>()!;

      if (talentsUpgrade.addSkillpoints > 0 ||
          talentsUpgrade.skillCeilingUpgrade > 0) {
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
      }

      if (talentsUpgrade.addSkillpoints > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.skip_next,
            "uitext_skillpointsupgrade",
            talentsUpgrade.addSkillpoints.toString()));
      }
      if (talentsUpgrade.skillCeilingUpgrade > 0) {
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.skip_next,
            "uitext_skillceilingupgrade",
            talentsUpgrade.skillCeilingUpgrade.toString()));
      }
    }

    if (buff!.has<ActionUserUpgradeComponent>()) {
      var actionUserUpgrade = buff!.get<ActionUserUpgradeComponent>()!;

      for (var entry in actionUserUpgrade.addedActions) {
        var actionEntity = entry.action;
        var actionTime = actionEntity.get<ActionComponent>()?.actionTime;

        if (actionTime == null) {
          continue;
        }
        if (widgets.isNotEmpty) {
          _addDivider(widgets);
        }
        widgets.add(SizedBox(height:6));
        widgets.add(Align(
            alignment: AlignmentGeometry.centerLeft,
            child:
                Text("${locator<TextService>().getText("uitext_actionUserUpgrade")}${locator<TextService>().getText(actionTime.getTextKey())}:")));
        widgets.add(SizedBox(height:6));
        var actionDesc =
            locator<TextService>().getActionDescriptionFromEntity(actionEntity);

        widgets.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(actionDesc)));
      }
    }
    return widgets;
  }

  Widget _buildValueUpgradeWidget(
      BuildContext context, IconData icon, String textKey, String value) {
    return Row(children: [
      const SizedBox(width: 12),
      Icon(icon),
      const SizedBox(width: 12),
      Expanded(child: Text(locator<TextService>().getText(textKey))),
      const SizedBox(width: 12),
      Align(alignment: Alignment.centerLeft, child: Text(value)),
      const SizedBox(width: 12),
    ]);
  }

  void _addDivider(List<Widget> widgets) => widgets.add(const Divider());
}

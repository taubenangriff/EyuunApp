import 'package:EyuunApp/components/health.dart';
import 'package:EyuunApp/components/upgrade/ArmorUpgrade.dart';
import 'package:EyuunApp/components/upgrade/Buff.dart';
import 'package:EyuunApp/components/upgrade/CharacterPathUpgrade.dart';
import 'package:EyuunApp/components/upgrade/FluxUpgrade.dart';
import 'package:EyuunApp/components/upgrade/LanguageLearnerUpgrade.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../components/upgrade/AttributesUpgrade.dart';
import '../../components/upgrade/CombatUpgrade.dart';
import '../../components/upgrade/HealthUpgrade.dart';
import '../../components/upgrade/TalentsUpgrade.dart';
import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';
import '../../core/services/assetloader.dart';

class BuffDisplay extends StatelessWidget {
  final String buff;
  late final Entity? _entity;

  BuffDisplay({super.key, required this.buff}) {
    _entity = locator<AssetLoader>().getStatic(buff);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildContent(context));
  }

  List<Widget> _buildContent(BuildContext context) {
    List<Widget> widgets = [];
    if (_entity == null) {
      widgets;
    }

    if (_entity!.has<BuffComponent>()) {
      var key = _entity.get<BuffComponent>()!.textDescription;
      if (key != "") {
        var desctext = locator<TextService>().getText(key);
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(desctext)));
      }
    }

    if (_entity.has<FluxUpgradeComponent>()) {

      if(widgets.isNotEmpty){
        _addDivider(widgets);
      }

      var fluxUpgrade = _entity.get<FluxUpgradeComponent>()!;
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

    if (_entity.has<ArmorUpgradeComponent>()) {
      var armorUpgrade = _entity.get<ArmorUpgradeComponent>()!;
      if (armorUpgrade.armorToughnessBonus > 0) {
        if(widgets.isNotEmpty){
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.shield,
            "uitext_armortoughnessupgrade",
            armorUpgrade.armorToughnessBonus.toString()));
      }
    }

    if (_entity.has<AttributesUpgradeComponent>()) {
      var attributesUpgrade = _entity.get<AttributesUpgradeComponent>()!;
      if (attributesUpgrade.maxDiceIncreasesUpgrade > 0) {
        if(widgets.isNotEmpty){
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.lunch_dining_outlined,
            "uitext_attributediceupgrade",
            attributesUpgrade.maxDiceIncreasesUpgrade.toString()));
      }
    }

    if (_entity.has<CharacterPathUpgradeComponent>()) {
      var characterPathUpgrade = _entity.get<CharacterPathUpgradeComponent>()!;
      if (characterPathUpgrade.pathCapacityUpgrade > 0) {
        if(widgets.isNotEmpty){
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.lunch_dining_outlined,
            "uitext_pathupgrade",
            characterPathUpgrade.pathCapacityUpgrade.toString()));
      }
    }

    if (_entity.has<CombatUpgradeComponent>()) {
      var combatUpgrade = _entity.get<CombatUpgradeComponent>()!;

      if(combatUpgrade.speedUpgrade > 0 || combatUpgrade.evasionUpgrade > 0 || combatUpgrade.initiativeUpgrade > 0 || combatUpgrade.actionsPerRoundUpgrade > 0 || combatUpgrade.reactionsPerRoundUpgrade > 0){
        if(widgets.isNotEmpty){
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

    if (_entity.has<HealthUpgradeComponent>()) {
      var healthUpgrade = _entity.get<HealthUpgradeComponent>()!;

      if (healthUpgrade.maxHitpointsUpgrade > 0 ||
          healthUpgrade.maxDeathThrowsUpgrade > 0) {
        if(widgets.isNotEmpty){
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

    if (_entity.has<LanguageLearnerUpgradeComponent>()) {
      var llUpgrade = _entity.get<LanguageLearnerUpgradeComponent>()!;

      if (llUpgrade.languageMaxPotentialUpgrade > 0) {
        if(widgets.isNotEmpty){
          _addDivider(widgets);
        }
        widgets.add(_buildValueUpgradeWidget(
            context,
            Icons.speaker_notes,
            "uitext_langpotentialupgrade",
            llUpgrade.languageMaxPotentialUpgrade.toString()));
      }
    }

    if (_entity.has<TalentsUpgradeComponent>()) {
      var talentsUpgrade = _entity.get<TalentsUpgradeComponent>()!;

      if(talentsUpgrade.addSkillpoints > 0 || talentsUpgrade.skillCeilingUpgrade > 0){
        if(widgets.isNotEmpty){
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

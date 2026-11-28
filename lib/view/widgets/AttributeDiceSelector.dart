import 'package:eyuuncore/components/Attribute.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/enums/AttributeImpactType.dart';
import 'package:eyuuncore/controller/CreateAttributesController.dart';
import 'package:eyuuncore/controller/CharacterGenerateStatsController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/DiceIcon.dart'; // your custom widget
import 'package:eyuunapp/view/widgets/StatItem.dart';
import 'package:oxygen/oxygen.dart'; // your custom widget

const Map<AttributeImpactType, IconData> _impactIcons = {
  AttributeImpactType.Health: Icons.favorite,
  AttributeImpactType.Flux: Icons.water,
  AttributeImpactType.NaturalArmor: Icons.shield,
  AttributeImpactType.LanguagePotential: Icons.speaker_notes,
  AttributeImpactType.Evasion: Icons.shield_outlined,
  AttributeImpactType.Inventory: Icons.inventory_2,
};

class AttributeDiceSelector extends StatefulWidget {
  final Entity character;
  late AttributesComponent _attributes;

  AttributeDiceSelector({super.key, required this.character}) {
    _attributes = character.get<AttributesComponent>()!;
  }

  @override
  State<AttributeDiceSelector> createState() => _AttributeDiceSelectorState();
}

class _AttributeDiceSelectorState extends State<AttributeDiceSelector> {
  final TextService textService = locator<TextService>();
  late final attributesController =
      CreateAttributesController(widget._attributes);
  late final characterGenerateStatsController =
      CharacterGenerateStatsController(widget.character);

  String _formatNumber(double value) => value == value.roundToDouble()
      ? value.round().toString()
      : value.toString();

  Widget _buildImpacts(AttributeEntry entry) {
    final attribute = entry.stat.get<AttributeComponent>();
    if (attribute == null) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      children: [
        for (final type in AttributeImpactType.values)
          if (attribute.hasImpact(type))
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_impactIcons[type], size: 24),
                const SizedBox(width: 2),
                Text(
                    "+${_formatNumber(entry.dice.getValue() * attribute.getImpact(type))}"),
              ],
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        locator<TextService>().getText('uitext_initattributes_remaining_cap') +
            attributesController.getRemainingDiceUpgrades().toString(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      Text(locator<TextService>().getText('uitext_initattributes_explainer')),
      const SizedBox(height: 16),
      ...widget._attributes.statValues.map((entry) {
        var dices =
            attributesController.getPossibleDices(entry.stat.getTypeId());

        return LayoutBuilder(builder: (context, constraints) {
          var aboveMinimal = constraints.maxWidth > 450;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: aboveMinimal ? 200 : 90),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textService.getTextFromEntity(entry.stat),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            _buildImpacts(entry),
                          ],
                        )),
                    Spacer(),
                    SegmentedButton<Dice>(
                      multiSelectionEnabled: false,
                      emptySelectionAllowed: false,
                      segments: dices
                          .map((opt) => ButtonSegment(
                                enabled: attributesController.canSet(
                                    entry.stat.getTypeId(), opt),
                                value: opt,
                                label: DiceIcon(
                                    type: opt, size: aboveMinimal ? 46 : 26),
                              ))
                          .toList(),
                      selected: {entry.dice},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          attributesController.setDice(
                              entry.stat.getTypeId(), newSelection.first);
                        });
                      },
                    ),
                  ],
                )),
          );
        });
      }),
      Divider(),
      SizedBox(height: 16),
      Text(locator<TextService>()
          .getText('uitext_initattributes_stat_calculate')),
      SizedBox(height: 16),
      Wrap(
        runSpacing: 24,
        spacing: 32,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          StatItem(
            icon: Icons.speaker_notes,
            label: textService
                .getText('uitext_initattributes_stat_language_potential'),
            value: characterGenerateStatsController.getLanguagePotential(),
          ),
          StatItem(
            icon: Icons.shield_outlined,
            label: textService.getText('uitext_initattributes_stat_evasion'),
            value: characterGenerateStatsController.getEvasion(),
          ),
          StatItem(
            icon: Icons.shield,
            label:
                textService.getText('uitext_initattributes_stat_natural_armor'),
            value: characterGenerateStatsController.getNaturalArmor(),
          ),
          StatItem(
            icon: Icons.favorite,
            label: textService.getText('uitext_initattributes_stat_health'),
            value: characterGenerateStatsController.getMaxHealth(),
          ),
          StatItem(
            icon: Icons.water,
            label: textService.getText('uitext_initattributes_stat_flux'),
            value: characterGenerateStatsController.getFlux(),
          ),
          StatItem(
            icon: Icons.inventory_2,
            label: textService.getText('uitext_initattributes_stat_inventory'),
            value: characterGenerateStatsController.getInventoryCapacity(),
          ),
        ],
      ),
      SizedBox(height: 16),
    ]);
  }
}

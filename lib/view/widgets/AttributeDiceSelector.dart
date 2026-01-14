import 'package:eyuuncore/controller/AttributesController.dart';
import 'package:eyuuncore/controller/CharacterGenerateStatsController.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:flutter/material.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:oxygen/oxygen.dart';

import 'DiceIcon.dart'; // your custom widget
import 'ItemWheel.dart';
import 'StatItem.dart'; // your custom widget

class AttributeDiceSelector extends StatefulWidget {
  final AttributesComponent attributes;

  const AttributeDiceSelector({super.key, required this.attributes});

  @override
  State<AttributeDiceSelector> createState() => _AttributeDiceSelectorState();
}

class _AttributeDiceSelectorState extends State<AttributeDiceSelector> {
  final TextService textService = locator<TextService>();
  late final attributesController = AttributesController(widget.attributes);
  late final characterGenerateStatsController =
      CharacterGenerateStatsController(widget.attributes);

  @override
  Widget build(BuildContext context) {
    return Column(children: [


      Text(
        locator<TextService>().getText('uitext_initattributes_remaining_cap') + attributesController.getRemainingDiceUpgrades().toString(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      Text(locator<TextService>().getText('uitext_initattributes_explainer')),
      const SizedBox(height: 16),

      ...widget.attributes.statValues.map((entry) {
        var dices =
            attributesController.getPossibleDicesAtCharCreation(entry.stat.id);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textService.getText(entry.stat.id),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SegmentedButton<Dice>(
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: false,
                    segments: dices
                        .map((opt) => ButtonSegment(
                              enabled: attributesController.canSet(
                                  entry.stat.id, entry.dice),
                              value: opt,
                              label: DiceIcon(type: opt),
                            ))
                        .toList(),
                    selected: {entry.dice},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        entry.dice = newSelection.first;
                      });
                    },
                  ),
                ],
              )),
        );
      }),
      Divider(),
      SizedBox(height: 16),
      Text("Your stat lineup will result in the following stats:"),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(
            icon: Icons.health_and_safety,
            label: 'Health',
            value: characterGenerateStatsController.getHealth(),
          ),
          StatItem(
            icon: Icons.water,
            label: 'Flux',
            value: characterGenerateStatsController.getFlux(),
          ),
          StatItem(
            icon: Icons.shield,
            label: 'Natural Armor',
            value: characterGenerateStatsController.getEvasion(),
          ),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(
            icon: Icons.speaker_notes,
            label: 'Language Potential',
            value: characterGenerateStatsController.getLanguagePotential(),
          ),
          StatItem(
            icon: Icons.shield_outlined,
            label: 'Evasion',
            value: characterGenerateStatsController.getEvasion(),
          ),
        ],
      ),
    ]);
  }
}

import 'dart:math';

import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/ItemWheel.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/controller/HealthLevelupController.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:flutter/material.dart';

class HealthLevelupWidget extends StatefulWidget {
  final HealthLevelupController controller;

  const HealthLevelupWidget({super.key, required this.controller});

  @override
  State<HealthLevelupWidget> createState() => _HealthLevelupWidgetState();
}

class _HealthLevelupWidgetState extends State<HealthLevelupWidget> {
  Widget _buildEntry(AttributeEntry entry, {required bool highlighted}) {
    return Expanded(
      child: Column(
        children: [
          DiceIcon(type: entry.dice, size: highlighted ? 64 : 44),
          const SizedBox(height: 8),
          Text(
            locator<TextService>().getTextFromEntity(entry.stat),
            style: TextStyle(
              fontSize: highlighted ? 18 : 14,
              fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();
    final controller = widget.controller;

    controller.refresh();

    return Column(
      children: [
        Text(
          textService.getText('text_health'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SegmentedButton<HealthIncreaseMode>(
          segments: [
            ButtonSegment(
              value: HealthIncreaseMode.maximum,
              label: Text(textService.getText('uitext_levelup_health_maximum')),
            ),
            ButtonSegment(
              value: HealthIncreaseMode.roll,
              label: Text(textService.getText('uitext_levelup_health_roll')),
            ),
          ],
          selected: {controller.mode},
          onSelectionChanged: (selection) =>
              setState(() => controller.mode = selection.first),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildEntry(controller.getMinimalDice(), highlighted: false),
              _buildEntry(controller.getMiddleDice(), highlighted: true),
              _buildEntry(controller.getMaximalDice(), highlighted: false),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (controller.mode == HealthIncreaseMode.roll) ...[
          SizedBox(
            width: 360,
            height: 70,
            child: ItemWheel(
              key: ValueKey(controller.getMiddleDice().dice),
              startValue: controller.getHealthIncrease(),
              minValue: 2,
              maxValue: 2 * controller.getMiddleDice().dice.getValue(),
              horizontal: true,
              valueCallback: (value) =>
                  setState(() => controller.rolledValue = value),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          textService.getText(
            'uitext_levelup_health_gain',
            formatArgs: [controller.getHealthIncrease().toString()],
          ),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildHealthPreview(controller.getHealthIncrease()),
      ],
    );
  }

  /// Non-interactive health button showing the state after the increase.
  Widget _buildHealthPreview(int increase) {
    final health = widget.controller.levelingEntity.get<HealthComponent>();
    if (health == null) return const SizedBox.shrink();
    final newHitpoints = health.hitpoints + increase;
    final newMaxHitpoints = health.maxHitpoints.current + increase;
    return IgnorePointer(
      child: EyuunWidgets.circularProgressButton(
        onPressed: () {},
        segments: max((newMaxHitpoints / 40).round() * 4, 4),
        progressColor: Colors.green.shade600,
        progress: newHitpoints / newMaxHitpoints,
        text:
            "${health.temporaryHitpoints > 0 ? "$newHitpoints+${health.temporaryHitpoints}" : "$newHitpoints"} / $newMaxHitpoints",
        icon: Icons.heart_broken,
      ),
    );
  }
}

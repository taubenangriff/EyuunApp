import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:flutter/material.dart';

class CombatStatsRow extends StatelessWidget {
  final CombatComponent combat;
  final SkillLearnerComponent skillLearner;

  const CombatStatsRow(
      {super.key, required this.combat, required this.skillLearner});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Combat Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(
              icon: Icons.directions_run,
              label: 'Speed',
              value: combat.speed.current,
            ),
            _StatItem(
              icon: Icons.shield_outlined,
              label: 'Evasion',
              value: combat.evasion.current,
            ),
            _StatItem(
              icon: Icons.flash_on,
              label: 'Initiative',
              value: combat.initiative.current,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(
                icon: Icons.rice_bowl,
                label: 'Melee attack',
                value: skillLearner.getSkillValue("fightingstyle_melee")),
            _StatItem(
                icon: Icons.tap_and_play_rounded,
                label: 'Range attack',
                value: skillLearner.getSkillValue("fightingstyle_range")),
          ],
        )
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

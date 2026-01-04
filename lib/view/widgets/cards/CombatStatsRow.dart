import 'package:flutter/material.dart';

import '../../../components/Combat.dart';

class CombatStatsRow extends StatelessWidget {
  final CombatComponent combat;

  const CombatStatsRow({
    super.key,
    required this.combat,
  });

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
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}


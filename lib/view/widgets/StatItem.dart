import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const StatItem({
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
        EyuunWidgets.spacerHorizontal(),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade400,
          ),
        ),
        EyuunWidgets.spacerHorizontal(),
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
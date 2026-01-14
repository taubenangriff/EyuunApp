import 'package:flutter/material.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:oxygen/oxygen.dart';

import '../popup/UpbringingPickerPopup.dart';
import '../widgets/eyuun/EyuunDecoration.dart';
import '../widgets/eyuun/Brushes.dart';
import '../widgets/BuffDisplay.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  final Entity? buff;

  const SelectionCard({
    required this.title,
    required this.onTap,
    required this.buff
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: EyuunDecoration(
        paint: Brushes.silverSparkling(),
        fillCorners: false,
        paintInnerLine: false,
        cornerSize: 14,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                BuffDisplay(buff: buff), // preexisting
              ],
            ),
          ),
        ),
      ),
    );
  }
}

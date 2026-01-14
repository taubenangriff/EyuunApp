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
  final String fallbackText;

  const SelectionCard(
      {required this.title,
      required this.onTap,
      required this.buff,
      fallbackText})
      : fallbackText = fallbackText ?? "";

  @override
  Widget build(BuildContext context) {
    final fluff = locator<TextService>().getFluffFromEntity(buff);

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              buff != null ? BuffDisplay(buff: buff) : Text(fallbackText),
              if (fluff.isNotEmpty) ...[
                const SizedBox(height: 16),
                Divider(
                  thickness: 2,
                  color: Colors.grey.withAlpha(100),
                ),
                const SizedBox(height: 12),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      fluff,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ))
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

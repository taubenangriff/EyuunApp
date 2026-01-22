import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';

class PauseRestPopup extends StatelessWidget {
  PauseRestPopup({super.key});

  final TextService textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(children: [
        Text(
          locator<TextService>().getText('uitext_restorpause'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: _ChoiceCard(
                    title: textService.getText('uitext_pause'),
                    description: textService.getText('uitext_pause_description'),
                    icon: Icons.pause,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 24),
                Flexible(
                  child: _ChoiceCard(
                    title: textService.getText('uitext_rest'),
                    description: textService.getText('uitext_rest_description'),
                    icon: Icons.hotel,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280),
      child: DecoratedBox(
        decoration: ArtDecoBoxDecoration(
            cornerBuilder: (p) => DoubleLineCornerPainter(p),
            verticalLineBuilder: (p) => DoubleLinePainter(p),
            horizontalLineBuilder: (p) => DoubleLinePainter(p),
            paint: Brushes.silverSparkling()..strokeWidth = 1.5,
            cornerSize: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 52),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

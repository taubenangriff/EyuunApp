import 'package:EyuunApp/view/widgets/BuffDisplay.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';
import '../widgets/eyuun/Brushes.dart';

class UpbringingPopup extends StatelessWidget {
  final Entity? primary;
  final Entity? secondary;

  const UpbringingPopup({
    required this.primary,
    required this.secondary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: EyuunDecoration(
        paint: Brushes.silverSparkling(),
        cornerSize: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _UpbringingColumn(
                title: locator<TextService>().getText("uitext_primary_upbringing"),
                entity: primary,
              ),
            ),
            if (secondary != null) const SizedBox(width: 24),
            if (secondary != null)
              Expanded(
                child: _UpbringingColumn(
                  title: locator<TextService>().getText("uitext_secondary_upbringing"),
                  entity: secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UpbringingColumn extends StatelessWidget {
  final String title;
  final Entity? entity;

  const _UpbringingColumn({
    required this.title,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    if (entity == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'None selected',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final textService = locator<TextService>();
    final fluff = textService.getFluffFromEntity(entity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16
          ),
        ),

        const SizedBox(height: 12),

        Text(
          textService.getTextFromEntity(entity),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        BuffDisplay(buff: entity),

        // ───────── Divider ─────────
        if (fluff.isNotEmpty) ...[
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
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
              )),
        ],
      ],
    );
  }
}

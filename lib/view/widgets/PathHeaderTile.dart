import 'package:eyuuncore/components/Path.dart';
import 'package:eyuunapp/view/enum/PathTypeColorExtension.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'StarRating.dart';

class PathHeaderTile extends StatelessWidget {
  final Entity pathEntity;

  PathHeaderTile({
    super.key,
    required this.pathEntity,
  });

  late var pathComponent = pathEntity.get<PathComponent>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade700,
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              pathComponent?.pathType.color.withAlpha(255) ??
                  Colors.transparent,
              Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withAlpha(100),
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                locator<TextService>().getTextFromEntity(pathEntity),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${pathComponent?.pickableSteps.length ?? 0} steps',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            const SizedBox(width: 12),
            StarRating(value: pathComponent?.complexity ?? 0),
            const SizedBox(width: 8),
          ],
        ));
  }
}

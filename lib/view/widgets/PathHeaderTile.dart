import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:eyuunapp/view/enum/PathTypeColorExtension.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/StarRating.dart';

class PathHeaderTile extends StatelessWidget {
  final Entity pathEntity;

  PathHeaderTile({
    super.key,
    required this.pathEntity,
  });

  late final pathComponent = pathEntity.get<PathComponent>();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: ArtDecoBoxDecoration(
        cornerBuilder: (paint) => ThickThinThickCornerPainter(paint),
        verticalLineBuilder: (paint) => ThickThinThickLinePainter(paint),
        horizontalLineBuilder: (paint) => ThickThinThickLinePainter(paint),
        paint: Brushes.goldSparkling()..strokeWidth = 1.25,
        cornerSize: 4,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              pathComponent?.pathType.color.withAlpha(255) ??
                  Colors.transparent,
              Theme.of(context).cardColor.withAlpha(200),
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Column(
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
        ),
      ),
    );
  }
}

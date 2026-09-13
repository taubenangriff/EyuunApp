import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/enum/RomanNumeralExtension.dart';
import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class PathStepTile extends StatelessWidget {
  final Entity pathStep;
  final PathController pathController;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const PathStepTile({
    super.key,
    required this.pathStep,
    required this.pathController,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPicked = pathController.isStepPicked(pathStep);
    final canPickStep = pathController.canPickStep(pathStep);

    final Paint brush;
    if (isPicked) {
      brush = Brushes.goldSparkling();
    } else if (canPickStep) {
      brush = Brushes.silverSparkling();
    } else {
      brush = Brushes.obsidianSparkling();
    }
    brush.strokeWidth = 1.25;

    Widget content = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟦 Roman numeral
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                ((pathStep.get<PathStepComponent>()?.tier ?? 0) + 1).toRoman(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 🟩 Content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Name
                Text(
                  locator<TextService>().getTextFromEntity(pathStep),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                EyuunWidgets.spacerVertical(),

                // 🔹 Buff display
                Center(
                  child: BuffDisplay(buff: pathStep),
                ),
              ],
            ),
          ),

          if (isPicked) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFFFFD966),
              size: 24,
            ),
          ],
        ],
      ),
    );

    if (!canPickStep && !isPicked) {
      content = Opacity(
        opacity: 0.5,
        child: content,
      );
    }

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: content,
        ),
      );
    }

    return DecoratedBox(
      decoration: ArtDecoBoxDecoration(
        cornerBuilder: (p) => DoubleLineCornerPainter(p),
        verticalLineBuilder: (p) => DoubleLinePainter(p),
        horizontalLineBuilder: (p) => DoubleLinePainter(p),
        paint: brush,
        background: theme.cardColor.withAlpha(180),
        cornerSize: 16,
      ),
      child: content,
    );
  }
}

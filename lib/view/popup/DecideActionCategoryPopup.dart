import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/popup/PickActionPopup.dart';

class DecideActionCategoryPopup extends StatelessWidget {
  const DecideActionCategoryPopup({
    super.key,
    required this.labels,
  });

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ArtDecoBoxDecoration(
        cornerBuilder: (p) => DoubleLineCornerPainter(p),
        verticalLineBuilder: (p) => DoubleLinePainter(p),
        horizontalLineBuilder: (p) => DoubleLinePainter(p),
        paint: Brushes.goldSparkling()..strokeWidth = 1.5,
        cornerSize: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            EyuunWidgets.spacerVertical(),
            Center(
              child: Text(
                locator<TextService>().getText('uitext_pickselectlist'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            EyuunWidgets.spacerVertical(),
            const Divider(),
            EyuunWidgets.spacerVertical(),

            for (int i = 0; i < labels.length; i++) ...[
              EyuunWidgets.floatingActionButton(
                height: 60,
                text: labels[i],
                onPressed: () {
                  Navigator.of(context).pop(i); // ✅ dialog result
                },
              ),
              if (i < labels.length - 1) EyuunWidgets.spacerVertical(),
            ],
          ],
        ),
      ),
    );
  }
}


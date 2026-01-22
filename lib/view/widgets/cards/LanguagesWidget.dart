import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:eyuunapp/view/popup/LanguageDetailPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/popup/SelectLanguagePopup.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/controller/LanguagesController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/decoration/Brushes.dart';

class LanguageGrid extends StatefulWidget {
  final LanguageLearnerComponent learner;
  final void Function(Entity language)? onLanguageTap;
  final VoidCallback? onAddLanguage;

  const LanguageGrid({
    super.key,
    required this.learner,
    this.onLanguageTap,
    this.onAddLanguage,
  });

  @override
  State<LanguageGrid> createState() => _LanguageGridState();
}

class _LanguageGridState extends State<LanguageGrid> {
  @override
  Widget build(BuildContext context) {
    final languages = widget.learner.languagesLearned;
    final languageController = LanguagesController(widget.learner);
    final textService = locator<TextService>();

    var languageWidgets = [
      for (final language in languages)
        DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: ArtDecoBoxDecoration(
                cornerBuilder: (p) => ThickThinThickCornerPainter(p),
                verticalLineBuilder: (p) => ThickThinThickLinePainter(p),
                horizontalLineBuilder: (p) => ThickThinThickLinePainter(p),
                paint: Brushes.goldSparkling()..strokeWidth = 1.25,
                cornerSize: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                PopupUtil.popup(
                    context, LanguageDetailPopup(languageEntity: language));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withAlpha(180)),
                child: Text(
                  textService.getTextFromEntity(language),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )),
      if (languageController.canLearnNew())
        DecoratedBox(
            position: DecorationPosition.foreground,
            decoration:
            ArtDecoBoxDecoration(
                cornerBuilder: (p) => ThickThinThickCornerPainter(p),
                verticalLineBuilder: (p) => ThickThinThickLinePainter(p),
                horizontalLineBuilder: (p) => ThickThinThickLinePainter(p),
                paint: Brushes.goldSparkling()..strokeWidth = 1.25,
                cornerSize: 5),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  PopupUtil.popup(
                      context,
                      SelectLanguagePopup(
                        languagesController: languageController,
                        onAccept: () {
                          setState(() {});
                        },
                      ),
                      maximumSize: Size(900, 700));
                });
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 28),
                  SizedBox(height: 4),
                  Text(
                    'Add Language',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
    ];

    return Column(
      children: [
        const Text(
          'Languages',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: const EdgeInsets.all(12),
          shrinkWrap: true, // fits inside other scrollables
          physics:
              const NeverScrollableScrollPhysics(), // avoid nested scrolling
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // 👈 desired item width
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 3.5, // tweak if needed
          ),
          itemCount: languageWidgets.length,
          itemBuilder: (BuildContext context, int index) {
            return languageWidgets[index];
          },
        )
      ],
    );
  }
}

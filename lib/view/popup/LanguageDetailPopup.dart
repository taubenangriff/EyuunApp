import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';
import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';
import '../widgets/LanguageDetailWidget.dart';

class LanguageDetailPopup extends StatelessWidget {
  final Entity languageEntity;

  const LanguageDetailPopup({
    super.key,
    required this.languageEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locator<TextService>().getTextFromEntity(languageEntity),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            LanguageDetailWidget(languageEntity: languageEntity),
          ],
        )
      );
  }
}

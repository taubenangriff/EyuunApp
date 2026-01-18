import 'package:eyuuncore/controller/LanguagesController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';
import '../widgets/LanguageDetailWidget.dart';
import '../widgets/SelectionCard.dart';
import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';

class UpbringingPickerPopup extends StatelessWidget {
  final List<Entity> possibleBuffs;
  final void Function(Entity) selectedBuffCallback;
  const UpbringingPickerPopup({required this.possibleBuffs, required this.selectedBuffCallback});

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Text(
          'Select',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: possibleBuffs.map((buff) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SelectionCard(
                        title: textService.getTextFromEntity(buff),
                        onTap: () {
                          Navigator.of(context).pop();
                          selectedBuffCallback.call(buff);
                        },
                        buff: buff,
                      ),
                    );
                  }).toList(),
                )))
      ]),
    );
  }
}

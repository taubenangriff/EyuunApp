import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ConfirmPathPopup extends StatelessWidget {
  const ConfirmPathPopup({required this.pathStep, super.key});

  final Entity pathStep;

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textService.getText('uitext_confirm_path'),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            textService.getTextFromEntity(pathStep),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: SingleChildScrollView(
              child: BuffDisplay(buff: pathStep),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EyuunWidgets.floatingActionButton(
                text: textService.getText('uitext_no'),
                width: 100,
                height: 40,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              EyuunWidgets.floatingActionButton(
                text: textService.getText('uitext_yes'),
                width: 100,
                height: 40,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

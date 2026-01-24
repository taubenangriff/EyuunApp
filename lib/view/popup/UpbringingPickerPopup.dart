import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/SelectionCard.dart';

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
        EyuunWidgets.spacerWidget(),
        Expanded(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: possibleBuffs.map((buff) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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

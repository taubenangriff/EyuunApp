import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class AcceptActionPopup extends StatelessWidget {
  final Entity? buff;

  const AcceptActionPopup({
    required this.buff,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buff != null
        ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(locator<TextService>().getTextFromEntity(buff!),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            EyuunWidgets.spacerVertical(),
            BuffDisplay(buff: buff),
            Center(child: EyuunWidgets.floatingActionButton(text: "Accept", onPressed: () => Navigator.of(context).pop(1)))
          ],
        ))
        : const SizedBox(width: 300, height: 200);
  }
}

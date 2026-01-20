import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';

class BuffDisplayPopup extends StatelessWidget {
  final Entity? buff;

  const BuffDisplayPopup({
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
              children: [
                Text(locator<TextService>().getTextFromEntity(buff!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                EyuunWidgets.spacerVertical(),
                BuffDisplay(buff: buff)
              ],
            ))
        : const SizedBox(width: 300, height: 200);
  }
}

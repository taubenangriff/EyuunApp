import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class BuffDisplayPopup extends StatelessWidget {
  final Entity? buff;
  final String? title;
  final String? subtitle;

  const BuffDisplayPopup({
    required this.buff,
    this.title,
    this.subtitle,
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
                Text(title ?? locator<TextService>().getTextFromEntity(buff!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                if (subtitle != null) Text(subtitle!),
                EyuunWidgets.spacerVertical(),
                BuffDisplay(buff: buff)
              ],
            ))
        : const SizedBox(width: 300, height: 200);
  }
}

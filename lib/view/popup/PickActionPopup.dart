import 'package:eyuunapp/view/widgets/PickActionWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class PickActionPopup extends StatelessWidget {
  final void Function(Entity entity)? onPicked;
  final String headerKey;
  final List<Entity> actions;

  const PickActionPopup({
    super.key,
    required this.headerKey,
    required this.actions,
    this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(children: [
          Text(
            locator<TextService>().getText(headerKey),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          EyuunWidgets.spacerVertical(),
          Expanded(
              child: PickActionWidget(
                  onPicked: onPicked,
                  actions: actions))
        ]));
  }
}

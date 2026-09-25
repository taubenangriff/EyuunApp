import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/controller/LevelController.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class LevelupPopup extends StatelessWidget {
  late final Entity? buff;
  final LevelController levelController;

  LevelupPopup({
    required this.levelController,
    super.key,
  }) {
    buff = levelController.getNextLevel();
  }

  @override
  Widget build(BuildContext context) {
    return buff != null
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Intro text
                Text(
                  locator<TextService>().getText("uitext_levelup_explainer"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Buff name
                Text(
                  locator<TextService>().getTextFromEntity(buff!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Buff effects
                BuffDisplay(buff: buff),

                const SizedBox(height: 24),

                Center(
                    child: EyuunWidgets.floatingActionButton(
                  text: locator<TextService>().getText("uitext_levelup"),
                  onPressed: levelController.canUpgrade()
                      ? () {
                          levelController.levelup();
                          Navigator.of(context).pop();
                        }
                      : null,
                )),
              ],
            ),
          )
        : const SizedBox(width: 300, height: 200);
  }
}

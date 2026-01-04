import 'package:EyuunApp/view/widgets/BuffDisplay.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';
import '../widgets/eyuun/Brushes.dart';

class LevelupPopup extends StatelessWidget {
  final Entity? buff;

  const LevelupPopup({
    required this.buff,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: EyuunDecoration(
        paint: Brushes.silverSparkling(),
        cornerSize: 12,
      ),
      child: buff != null
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
                      child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: EyuunDecoration(
                        paint: Brushes.goldSparkling(), cornerSize: 12),
                    child: ElevatedButton(
                      onPressed: null, //TODO add levelup
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Text(
                          locator<TextService>().getText("uitext_levelup"),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            )
          : const SizedBox(width: 300, height: 200),
    );
  }
}

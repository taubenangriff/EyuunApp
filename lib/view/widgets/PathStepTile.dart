import 'package:eyuunapp/view/enum/RomanNumeralExtension.dart';
import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';


class PathStepTile extends StatelessWidget {
  final Entity pathStep;
  final PathController pathController;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final bool canPick;

  const PathStepTile({
    super.key,
    required this.pathStep,
    required this.pathController,
    this.onTap,
    this.canPick = false,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final typeId = pathStep.getTypeId();
    final isPicked = this.canPick && pathController.isStepPicked(typeId);
    final canPick = this.canPick && pathController.canPickStep(typeId);

    final content = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟦 Roman numeral
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                ((pathStep.get<PathStepComponent>()?.tier ?? 0) + 1).toRoman(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 32),

          // 🟩 Content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Name
                Text(
                  locator<TextService>().getText(typeId),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPicked
                        ? Colors.grey.shade400
                        : (canPick
                        ? Colors.orangeAccent
                        : Colors.grey.shade700),
                  ),
                ),
                EyuunWidgets.spacerVertical(),

                // 🔹 Buff display
                Center(
                  child: BuffDisplay(buff: pathStep),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Optional interaction wrapper
    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orangeAccent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }
}
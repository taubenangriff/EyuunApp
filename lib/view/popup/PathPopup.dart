import 'dart:math';

import 'package:EyuunApp/components/Path.dart';
import 'package:EyuunApp/components/PathStep.dart';
import 'package:EyuunApp/core/assetLink.dart';
import 'package:EyuunApp/core/components/EntityExtensions.dart';
import 'package:EyuunApp/core/services/assetloader.dart';
import 'package:EyuunApp/view/enum/RomanNumeralExtension.dart';
import 'package:EyuunApp/view/widgets/BuffDisplay.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:oxygen/oxygen.dart';

import '../../controller/PathController.dart';
import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';
import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';

class PathPopup extends StatefulWidget {
  final void Function(String)? onSubmitted;
  final void Function(void Function())? setState;
  final String pathId;

  final PathController pathController;

  const PathPopup(
      {this.onSubmitted,
      this.setState,
      this.pathId = "",
      required this.pathController,
      super.key});

  @override
  State<PathPopup> createState() => _PathPopupState();
}

class _PathPopupState extends State<PathPopup> {
  var maxSkilled = 1;
  bool canSelectNew = true;

  _increasePath() {
    setState(() {
      maxSkilled++;
      canSelectNew = false;
    });
  }

  _buildPath(Entity pathStep) {
    var typeId = pathStep.getTypeId();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟦 Roman numeral (left, vertically centered)
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

          // 🟩 Right side content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Name (top, centered)
                Text(
                  locator<TextService>().getText(typeId),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.pathController.isStepPicked(typeId)
                        ? Colors.grey.shade400
                        : (widget.pathController.canPickStep(typeId)
                            ? Colors.orangeAccent
                            : Colors.grey.shade700),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔹 Display (center-centered)
                Center(
                  child: BuffDisplay(buff: typeId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pathAsset = locator<AssetLoader>().getStatic("path_flux_01");
    var pathSteps =
        pathAsset?.get<PathComponent>()?.pickableSteps.getAssets() ?? [];

    return DecoratedBox(
        decoration:
            EyuunDecoration(paint: Brushes.silverSparkling(), cornerSize: 12),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              children: [
                Text(
                  locator<TextService>().getTextFromEntity(pathAsset!),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                for (var (index, step) in pathSteps.indexed) ...[
                  widget.pathController.canPickNewPath() &&
                          widget.pathController.canPickStep(step.getTypeId())
                      ? InkWell(
                          onTap: _increasePath,
                          child: Container(
                              decoration: BoxDecoration(
                                // optional background
                                border: Border.all(
                                  color: Colors.orangeAccent, // border color
                                  width: 1, // border thickness
                                ),
                                borderRadius:
                                    BorderRadius.circular(8), // rounded corners
                              ),
                              child: _buildPath(step)))
                      :
                      //these paths are just for display.
                      _buildPath(step),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ));
  }
}

import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/services/assetloader.dart';
import 'package:flutter/material.dart';

import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';
import '../widgets/PathStepTile.dart';

class PathPopup extends StatefulWidget {
  final void Function(String)? onSubmitted;
  final void Function(void Function())? setState;
  final String pathId;

  final PathController pathController;

  const PathPopup(
      {this.onSubmitted,
      this.setState,
      required this.pathId,
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

  @override
  Widget build(BuildContext context) {
    var pathAsset = locator<GameObjectService>().getStatic(widget.pathId);
    var pathSteps =
        pathAsset?.get<PathComponent>()?.pickableSteps.getAssets() ?? [];

    return DecoratedBox(
      decoration: EyuunDecoration(
        paint: Brushes.silverSparkling(),
        cornerSize: 12,
      ),
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

              for (final step in pathSteps) ...[
                PathStepTile(
                  pathStep: step,
                  pathController: widget.pathController,
                  onTap: widget.pathController.canPickNewPath() &&
                      widget.pathController.canPickStep(step.getTypeId())
                      ? _increasePath
                      : null,
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

}

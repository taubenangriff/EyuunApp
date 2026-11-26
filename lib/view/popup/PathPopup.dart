import 'package:eyuunapp/view/popup/ConfirmPathPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/PathStepTile.dart';

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
    var pathSteps = pathAsset?.get<PathComponent>()?.pickableSteps ?? [];

    return SingleChildScrollView(
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
                        widget.pathController.canPickStep(step)
                    ? () async {
                        final confirmed = await PopupUtil.popup<bool>(
                          maximumSize: Size(400, 700),
                          context,
                          ConfirmPathPopup(pathStep: step),
                        );
                        if (!mounted || confirmed != true) return;

                        setState(() {
                          widget.pathController.pickStep(step);
                          widget.onSubmitted?.call(widget.pathId);
                        });
                      }
                    : null,
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

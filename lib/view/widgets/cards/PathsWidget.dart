import 'package:eyuunapp/view/popup/PathPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';
import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../enum/PathTypeColorExtension.dart';
import '../../popup/BuffDisplayPopup.dart';
import '../../popup/PickPathPopup.dart';
import '../eyuun/Brushes.dart';

class PathsWidget extends StatefulWidget {
  const PathsWidget({super.key});

  @override
  State<PathsWidget> createState() => _PathsWidgetState();
}

class _PathsWidgetState extends State<PathsWidget> {
  static const int maxValue = 10;
  bool canAddAdditional = true;

  var character = locator<CharacterService>().character;

  late var pathController = PathController(character);
  late var pathComponent = character.get<CharacterPathComponent>();

  Widget _buildAddNewAdditionalPathButton(
      BuildContext context, VoidCallback onPressed) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hideText = constraints.maxWidth < 100; // hide text if too narrow

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 32), // ✅ plus icon
              if (!hideText) ...[
                const SizedBox(height: 4),
                const Text(
                  'Add New',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdditionalPathButton(
      BuildContext context, Entity additionalPathItem) {
    var pathStep = additionalPathItem.get<PathStepComponent>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hideText = constraints.maxWidth < 100; // hide text if too narrow

        return DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: EyuunDecoration(
                paint: Brushes.goldSparkling(),
                cornerSize: 12,
                fillCorners: true),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pathStep.pathType.color,
                foregroundColor: pathStep.pathType.textColor,
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => setState(() {
                PopupUtil.popup(
                    context, BuffDisplayPopup(buff: additionalPathItem));
              }),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 32),
                  if (!hideText) ...[
                    const SizedBox(height: 4),
                    Text(
                      locator<TextService>()
                          .getText(additionalPathItem.getTextKey()),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var additionalPathWidgets = pathController
        .getChosenAdditionalPaths()
        .map((item) => _buildAdditionalPathButton(context, item))
        .toList();

    if (pathController.canPickAdditional()) {
      additionalPathWidgets.add(_buildAddNewAdditionalPathButton(
          context,
          () => setState(() {
                PopupUtil.popup(
                    context,
                    const Center(
                        child: Text(
                            "Popup showing all available Additional Paths first, then the rest you cannot yet pick.")),
                    maximumSize: Size(900, 700));
              })));
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Paths',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        EyuunWidgets.spacerVertical(),

        // Progress bars
        ...pathController.getChosenPaths().map((path) {
          var pathId = path.getTypeId();
          var pathComponent = path.get<PathComponent>() ?? PathComponent();

          var progress = pathController.getPathProgress(pathId);
          var progressMax = pathController.getPathMaximum(pathId);

          if (progressMax < 1) {
            progressMax = 1;
          }

          var pathType = pathComponent.pathType;

          return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(4),
                  decoration: EyuunDecoration(
                      paint: Brushes.silverSparkling(),
                      fillCorners: false,
                      paintInnerLine: false,
                      cornerSize: 8),
                  child: InkWell(
                  onTap: () {
                    PopupUtil.popup(
                        context,
                        PathPopup(
                            pathController: pathController,
                            pathId: path.getTypeId()),
                        maximumSize: Size(1000, 900));
                  },
                  borderRadius:
                      BorderRadius.circular(8), // optional for ripple effect
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          // Title on the left
                          SizedBox(
                            width: 120,
                            child: Text(
                              locator<TextService>().getTextFromEntity(path),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          // Progress bar with number
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final barWidth = constraints.maxWidth;
                                final position =
                                    (progress / progressMax) * barWidth;

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Base bar
                                    Container(
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: theme.splashColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    // Filled progress
                                    Container(
                                      width: position,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: pathType.color,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    // Number at progress
                                    Positioned(
                                      left: position -
                                          20, // adjust so text is centered
                                      top: -6,
                                      bottom: -6,
                                      child: Center(
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: EyuunDecoration(
                                              paint: Brushes.goldSparkling(),
                                              background: pathType.color,
                                              fillCorners: false,
                                              cornerSize: 8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$progress',
                                            style: TextStyle(
                                              color: pathType.textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ))
                  // replace with your widget
                  )));
        }),
        if (pathController.canPickNewPath()) const SizedBox(height: 16),
        if (pathController.canPickNewPath())
          SizedBox(
              width: 160,
              height: 46,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      PopupUtil.popup(context,
                          PickPathPopup(pathController: pathController),
                          maximumSize: Size(900, 700));
                    });
                  },
                  child: Text('+ Add new Path'))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // avoid nested scrolling
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120, // 👈 desired item width
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1, // tweak if needed
          ),
          itemCount: additionalPathWidgets.length,
          itemBuilder: (context, index) {
            return additionalPathWidgets[index];
          },
        )
      ],
    );
  }
}

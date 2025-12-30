import 'dart:math';

import 'package:EyuunApp/view/popup/PathPopup.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:flutter/material.dart';

import '../../enums/PathType.dart';
import '../enum/PathTypeColorExtension.dart';

class PathsWidget extends StatefulWidget {
  const PathsWidget({super.key});

  @override
  State<PathsWidget> createState() => _PathsWidgetState();
}

class PathValue {
  String name;
  int progress;
  int additional;
  final PathType type;

  PathValue(this.name, this.progress, this.additional, this.type);
}

class AdditionalPathItem {
  final String name;
  final String pathName;
  final String icon;
  final PathType type;

  AdditionalPathItem(
      {required this.name,
      required this.pathName,
      required this.icon,
      required this.type});
}

class _PathsWidgetState extends State<PathsWidget> {
  static const int maxValue = 10;
  bool canAddAdditional = true;

  late final List<PathValue> progressValues = [
    PathValue("CrafterPath", 3, 0, PathType.Crafter),
    PathValue("FighterPath", 5, 0, PathType.Fighter),
    PathValue("FlowPath", 7, 0, PathType.Flux),
    PathValue("AcolytePath", 1, 4, PathType.Acolyte)
  ];

  final List<AdditionalPathItem> additionalPaths = [
    AdditionalPathItem(
        name: "Flow Add1",
        pathName: "Flow1",
        icon: "icon",
        type: PathType.Flux),
    AdditionalPathItem(
        name: "Crafter Add2",
        pathName: "CrafterSub1",
        icon: "icon",
        type: PathType.Crafter),
    AdditionalPathItem(
        name: "Acolyte Add2",
        pathName: "AcolyteSub2",
        icon: "icon",
        type: PathType.Acolyte),
    AdditionalPathItem(
        name: "Acolyte Add4",
        pathName: "AcolyteSub",
        icon: "icon",
        type: PathType.Acolyte)
  ];

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
      BuildContext context, AdditionalPathItem item) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hideText = constraints.maxWidth < 100; // hide text if too narrow

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: item.type.color,
            foregroundColor: item.type.textColor,
            padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => setState(() {}),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 32),
              if (!hideText) ...[
                const SizedBox(height: 4),
                Text(
                  item.name,
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

  @override
  Widget build(BuildContext context) {

    var additionalPathWidgets = additionalPaths
        .map((item) => _buildAdditionalPathButton(context, item))
        .toList();

    if (canAddAdditional) {
      additionalPathWidgets.add(_buildAddNewAdditionalPathButton(
          context,
          () => setState(() {
                PopupUtil.popup(
                    context,
                    const Center(child: Text(
                        "Popup showing all available Additional Paths first, then the rest you cannot yet pick."))
                    ,
                    maximumSize: Size(900, 700));
                additionalPaths.add(AdditionalPathItem(
                    name: "Fighter Add1",
                    pathName: "Fighter",
                    icon: "icon",
                    type: PathType.Fighter));
                canAddAdditional = false;
              })));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Paths',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Progress bars
        ...progressValues.map((path) {
          return Padding(
              padding: const EdgeInsets.all(2),
              child: InkWell(
                  onTap: () {
                    PopupUtil.popup(context, PathPopup(),
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
                              path.name,
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
                                    (path.progress / maxValue) * barWidth;

                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Base bar
                                    Container(
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    // Filled progress
                                    Container(
                                      width: position,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: path.type.color,
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
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2),
                                            color: path.type.color,
                                            borderRadius: BorderRadius.circular(
                                                25), // circular knob
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${path.progress}',
                                            style: TextStyle(
                                              color: path.type.textColor,
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
                  ));
        }),
        const SizedBox(height: 16),
        GridView.count(
            shrinkWrap: true, // so it fits inside other scrollables
            physics:
                const NeverScrollableScrollPhysics(), // avoid nested scrolling
            crossAxisCount: 7, // ✅ 7 buttons per row
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1, // square buttons
            children: additionalPathWidgets)
      ],
    );
  }
}

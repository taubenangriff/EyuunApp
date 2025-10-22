import 'dart:math';

import 'package:flexbackend/view/popup/PathPopup.dart';
import 'package:flutter/material.dart';

class PathsWidget extends StatefulWidget {
  const PathsWidget({super.key});

  @override
  State<PathsWidget> createState() => _PathsWidgetState();
}

class PathValue {
  String name;
  int progress;
  int additional;

  PathValue(this.name, this.progress, this.additional);
}

class _PathsWidgetState extends State<PathsWidget> {
  static const int maxValue = 10;

  late final List<PathValue> progressValues = [
    PathValue("Bard", 3, 0),
    PathValue("Adventurer", 5, 0),
    PathValue("Retard", 7, 0),
    PathValue("Kung Fu Panda", 1, 4)
  ];

  void _showPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 800, maxWidth: 1000), // max popup height
            child: PathPopup(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    onTap: _showPopup,
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      // Filled progress
                                      Container(
                                        width: position,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25), // circular knob
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${path.progress}',
                                              style: const TextStyle(
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
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                                width: 60,
                                child: Center(
                                    child: Row(children: [
                                      const Icon(Icons.extension_outlined),
                                  const SizedBox(width: 10),
                                  Text('${path.additional}'),
                                ])))
                          ],
                        ))
                    // replace with your widget
                    ));
          }),
        ],
      ),
    );
  }
}

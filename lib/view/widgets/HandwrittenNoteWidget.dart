import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

import 'eyuun/EyuunWidgets.dart';

class HandwrittenNoteWidget extends StatefulWidget {
  @override
  State<HandwrittenNoteWidget> createState() => _HandwrittenNoteWidgetState();
}

class _HandwrittenNoteWidgetState extends State<HandwrittenNoteWidget> {
  final DrawingController _drawingController = DrawingController(
    config: DrawConfig(
      contentType: SimpleLine,
      strokeWidth: 1.0,
      color: Colors.black,
    ),
  );

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _drawingController.setPaintContent(SmoothLine(
      brushPrecision:
          0.9, // Line smoothness factor (smaller = smoother, default: 0.8)
      useBezierCurve: true, // Enable Bezier curves (default: true)
      minPointDistance: 0.5, // Filter redundant points (default: 2.0)
      smoothLevel: 0, // 0: fast, 1: balanced, 2: ultra-smooth (default: 1)
    ));
    _drawingController.setStyle(
      color: Colors.black,
      strokeWidth: 4.0,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
      blendMode: BlendMode.srcOver,
      isAntiAlias: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Card(
              elevation: 8,
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    EyuunWidgets.spacerVertical(),
                    // Action Bar (slider, undo, redo, rotate, clear)
                    DrawingBar(
                        style: const VerticalToolsBarStyle(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                        ),
                        controller: _drawingController,
                        tools: [
                          DefaultToolItem.pen().adjustStyle(),
                          DefaultToolItem.eraser().adjustStyle(),
                          DefaultToolItem.rectangle().adjustStyle(),
                          DefaultToolItem.circle().adjustStyle(),
                          DefaultToolItem.straightLine().adjustStyle(),
                          DefaultActionItem.undo().adjustStyle(
                              (BuildContext context,
                                  DrawingController controller) {
                            return Icon(
                              Icons.turn_left,
                              color:
                                  controller.canUndo() ? Colors.white70 : null,
                              size: 24,
                            );
                          }),
                          DefaultActionItem.redo().adjustStyle(
                              (BuildContext context,
                                  DrawingController controller) {
                            return Icon(
                              Icons.turn_right,
                              color:
                                  controller.canRedo() ? Colors.white70 : null,
                              size: 24,
                            );
                          }),
                          DefaultActionItem.clear().adjustStyle(
                              (BuildContext context,
                                  DrawingController controller) {
                            return Icon(
                              Icons.clear,
                              color:
                                  controller.canClear() ? Colors.white70 : null,
                              size: 24,
                            );
                          }),
                        ]),
                    EyuunWidgets.spacerVertical(),
                  ])))), // Drawing Board
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
            ),
            BoxShadow(
              color: Colors.white,
              spreadRadius: -4.0,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: DrawingBoard(
          controller: _drawingController,
          boardConstrained: true,
          boardPanEnabled: false,
          enablePalmRejection: true,
          boardScaleEnabled: false,
          maxScale: 3,
          minScale: 1,
          background: Container(color: Colors.white),
        ),
      ),
    );
  }
}

extension DefaultToolChangeStyleExtension on DefaultToolItem {
  DefaultToolItem adjustStyle() {
    return DefaultToolItem(
      icon: icon,
      content: content,
      onTap: onTap,
      backgroundColor: Colors.transparent,
      activeColor: Colors.orangeAccent,
      color: Colors.white70,
      iconSize: 24,
    );
  }
}

extension DefaultActionChangeStyleExtension on DefaultActionItem {
  DefaultActionItem adjustStyle(
      Widget Function(BuildContext context, DrawingController controller)
          overrideChildBuilder) {
    return DefaultActionItem(
      childBuilder: overrideChildBuilder,
      onTap: onTap,
      backgroundColor: Colors.transparent,
    );
  }
}

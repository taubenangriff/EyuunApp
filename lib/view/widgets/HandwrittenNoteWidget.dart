import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

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
      brushPrecision: 0.8,   // Line smoothness factor (smaller = smoother, default: 0.8)
      useBezierCurve: true,  // Enable Bezier curves (default: true)
      minPointDistance: 2.0, // Filter redundant points (default: 2.0)
      smoothLevel: 1,        // 0: fast, 1: balanced, 2: ultra-smooth (default: 1)
    ));
    _drawingController.setStyle(
      color: Colors.black,
      strokeWidth: 6.0,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
      blendMode: BlendMode.srcOver,
      isAntiAlias: true,
    );
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        // Action Bar (slider, undo, redo, rotate, clear)
        DrawingBar(
          controller: _drawingController,
          tools: [
            DefaultActionItem.slider(),
            DefaultActionItem.undo(),
            DefaultActionItem.redo(),
            DefaultActionItem.clear(),
          ],
        ),

        // Tool Bar (pen, brush, shapes, eraser)
        DrawingBar(
          controller: _drawingController,
          tools: [
            DefaultToolItem.pen(),
            DefaultToolItem.eraser(),
            DefaultToolItem.rectangle(),
            DefaultToolItem.circle(),
            DefaultToolItem.straightLine(),
          ],
        ),
        // Drawing Board
        Expanded(
          child: DrawingBoard(
            controller: _drawingController,
            boardConstrained: true,
            boardScaleEnabled: false,
            background: Container(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

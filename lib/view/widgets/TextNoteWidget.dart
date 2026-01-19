import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

import 'eyuun/EyuunWidgets.dart';

class TextNoteWidget extends StatefulWidget {
  @override
  State<TextNoteWidget> createState() => _TextNoteWidgetState();
}

class _TextNoteWidgetState extends State<TextNoteWidget> {
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
    var theme = Theme.of(context);

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: theme.textTheme.headlineLarge?.copyWith(foreground: Paint()..color = Colors.white70),
                    hintText: "Title"),
                maxLines: 1,
              ),
              Expanded(
                  child: TextField(
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(foreground: Paint()..color = Colors.white38),
                    hintText: "click into the text field and start typing..."),
                expands: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ))
            ])));
  }
}

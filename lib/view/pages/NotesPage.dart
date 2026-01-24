import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ScaffoldCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/LinePainter.dart';
import 'package:eyuunapp/view/widgets/HandwrittenNoteWidget.dart';
import 'package:eyuunapp/view/widgets/TextNoteWidget.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Widget selectedWidget = HandwrittenNoteWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 1100;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: ArtDecoBoxDecoration(
                        cornerBuilder: (p) =>
                            ScaffoldCornerPainter(p, squareSize: 6),
                        verticalLineBuilder: (p) => LinePainter(p),
                        horizontalLineBuilder: (p) => LinePainter(p),
                        cornerSize: 16,
                        paint: Brushes.goldSparkling()),
                    child: selectedWidget))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              setState(() {
                selectedWidget = TextNoteWidget();
              });
            },
            text: 'New',
            tooltip: 'Add a new Text Note',
            icon: Icons.keyboard_alt_outlined,
          ),
          EyuunWidgets.spacerHorizontal(),
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              setState(() {
                selectedWidget = HandwrittenNoteWidget();
              });
            },
            text: 'New',
            tooltip: 'Add a new Handwritten Note',
            icon: Icons.draw,
          ),
        ],
      ),
    );
  }
}

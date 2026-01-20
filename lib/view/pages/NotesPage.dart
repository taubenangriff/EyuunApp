import 'package:eyuunapp/view/widgets/HandwrittenNoteWidget.dart';
import 'package:eyuunapp/view/widgets/TextNoteWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';

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
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desiredSize),
            child: Padding(
                padding: EdgeInsets.all(20),
                child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: EyuunDecoration(
                        cornerSize: 20,
                        paintInnerLine: false,
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

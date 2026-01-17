import 'package:eyuunapp/view/widgets/HandwrittenNoteWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
                    child: HandwrittenNoteWidget()))),
      ),
    );
  }
}

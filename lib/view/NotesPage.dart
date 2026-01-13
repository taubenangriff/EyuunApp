import 'package:EyuunApp/view/widgets/HandwrittenNoteWidget.dart';
import 'package:EyuunApp/view/widgets/eyuun/Brushes.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: desiredSize,
                    maxHeight: 2000,
                    minHeight: 200,
                    minWidth: 200),
                child: DecoratedBox(
                    decoration: EyuunDecoration(
                        cornerSize: 20,
                        paint: Brushes.goldSparkling()),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: HandwrittenNoteWidget())))),
      ),
    );
  }
}

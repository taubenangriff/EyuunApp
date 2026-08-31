import 'package:eyuunapp/view/Note.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/HandwrittenNoteWidget.dart';
import 'package:eyuunapp/view/widgets/NoteCard.dart';
import 'package:eyuunapp/view/widgets/TextNoteWidget.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> notes = [
    const Note(
      type: NoteType.text,
      heading: 'Ashen Market Leads',
      text: 'The apothecary knows who purchased the silvered salt.',
    ),
    const Note(
      type: NoteType.handwritten,
      heading: 'Map of the Old Quarter',
      text: '',
      previewImage: 'data/base/ui/bg/note.png',
    ),
    const Note(
      type: NoteType.text,
      heading: 'Party Supplies',
      text: 'Lantern oil, rope, dried rations, and a fresh healing kit.',
    ),
    const Note(
      type: NoteType.handwritten,
      heading: 'Rune Fragment',
      previewImage: 'data/base/ui/bg/note.png',
      text: '',
    ),
  ];

  void _openNote(Note note) {
    PopupUtil.largePopup(
      context,
      note.type == NoteType.text ? TextNoteWidget() : HandwrittenNoteWidget(),
      header: note.heading.isEmpty ? 'New Note' : note.heading,
      background: const AssetImage('data/base/ui/bg/background.jpg'),
    );
  }

  void _openNewNote(NoteType type) {
    final note = Note(
      type: type,
      heading: type == NoteType.text ? 'New Text Note' : 'New Handwritten Note',
      text: type == NoteType.text ? 'Start writing your note here.' : '',
    );

    setState(() {
      notes.add(note);
    });
    _openNote(note);
  }

  void _deleteNote(Note note) {
    setState(() {
      notes.remove(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    const desiredSize = 1100.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: desiredSize),
            child: EyuunWidgets.cardBox(
              theme: Theme.of(context),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 300,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteCard(
                  note: notes[index],
                  onTap: () => _openNote(notes[index]),
                  onDelete: () => _deleteNote(notes[index]),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              _openNewNote(NoteType.text);
            },
            text: 'New',
            tooltip: 'Add a new Text Note',
            icon: Icons.keyboard_alt_outlined,
          ),
          EyuunWidgets.spacerHorizontal(),
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              _openNewNote(NoteType.handwritten);
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

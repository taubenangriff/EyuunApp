enum NoteType {
  text,
  handwritten,
}

class Note {
  const Note({
    required this.type,
    required this.heading,
    required this.text,
    this.previewImage,
  });

  final NoteType type;
  final String heading;
  final String text;
  final String? previewImage;
}

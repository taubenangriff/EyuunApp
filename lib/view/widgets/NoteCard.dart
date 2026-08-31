import 'package:eyuunapp/view/Note.dart';
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
  });

  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTextNote = note.type == NoteType.text;
    final noteTypeLabel = isTextNote ? 'Text Note' : 'Handwritten Note';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        borderOnForeground: true,
        elevation: 6,
        surfaceTintColor: theme.colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: ArtDecoBoxDecoration(
            cornerBuilder: (p) => ThickThinThickCornerPainter(p),
            verticalLineBuilder: (p) => ThickThinThickLinePainter(p),
            horizontalLineBuilder: (p) => ThickThinThickLinePainter(p),
            paint: Brushes.goldSparkling()..strokeWidth = 1.25,
            cornerSize: 5,
          ),
          child: Stack(
            children: [
              if (note.previewImage != null)
                Positioned.fill(
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.white],
                      stops: [0.1, 1.1],
                    ).createShader(bounds),
                    child: Image.asset(
                      note.previewImage!,
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(isTextNote ? Icons.notes : Icons.draw),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            noteTypeLabel,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete note',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      note.heading,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge,
                    ),
                    if (note.previewImage == null && isTextNote) ...[
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          note.text,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

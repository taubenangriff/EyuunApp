import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter/services.dart';

class NameableComponent {
  String name;
  NameableComponent(this.name);
}

class CharacterPortraitPicker extends StatefulWidget {
  final NameableComponent nameable;

  const CharacterPortraitPicker({
    super.key,
    required this.nameable,
  });

  @override
  State<CharacterPortraitPicker> createState() =>
      _CharacterPortraitPickerState();
}

class _CharacterPortraitPickerState extends State<CharacterPortraitPicker> {
  late final TextEditingController _controller;
  DropzoneViewController? _dropzoneController;

  ImageProvider? _portrait;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nameable.name);
    _controller.addListener(() {
      widget.nameable.name = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleUrlDrop(String data) {
    final uri = Uri.tryParse(data.trim());

    if (uri == null || !uri.hasScheme) {
      return;
    }

    // Accept http / https only
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return;
    }
    setState(() {
      _portrait = NetworkImage(uri.toString());
      _dragging = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: EyuunDecoration(
                paint: Brushes.silverSparkling(),
                cornerSize: 16,
              ),
              child: SizedBox(
                width: 380,
                height: 380,
                child: Stack(
                  children: [
                    // 🖼 Portrait
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: _dragging
                              ? Border.all(color: Colors.orangeAccent, width: 2)
                              : null,
                          image: _portrait != null
                              ? DecorationImage(
                                  image: _portrait!,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _portrait == null
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 48,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Drop image here\nor paste',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),

                    // 🧲 Dropzone overlay
                    DropzoneView(
                      onCreated: (ctrl) => _dropzoneController = ctrl,
                      onHover: () => setState(() => _dragging = true),
                      onLeave: () => setState(() => _dragging = false),
                      onDropString: _handleUrlDrop,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Character Name',
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

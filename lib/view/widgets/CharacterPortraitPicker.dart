import 'dart:io';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:eyuunapp/services/ImageService.dart';
import 'package:eyuunapp/view/controller/CharacterImageController.dart';
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:eyuuncore/controller/PickUpbringingController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/PersonSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:image_picker/image_picker.dart';

class NameableComponent {
  String name;
  NameableComponent(this.name);
}

class CharacterPortraitPicker extends StatefulWidget {
  final NameableComponent nameable;
  final PickUpbringingController upbringingController;
  final CharacterImageController imageController;

  const CharacterPortraitPicker(
      {super.key,
      required this.nameable,
      required this.upbringingController,
      required this.imageController});

  @override
  State<CharacterPortraitPicker> createState() =>
      _CharacterPortraitPickerState();
}

class _CharacterPortraitPickerState extends State<CharacterPortraitPicker> {
  late final TextEditingController _controller;
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

  @override
  Widget build(BuildContext context) {
    var sizes = widget.upbringingController.getPossibleSizes();
    var textService = locator<TextService>();

    return Focus(
      autofocus: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: ArtDecoBoxDecoration(
                  cornerBuilder: (p) => ThickThinThickCornerPainter(p),
                  verticalLineBuilder: (p) => ThickThinThickLinePainter(p),
                  horizontalLineBuilder: (p) => ThickThinThickLinePainter(p),
                  paint: Brushes.goldSparkling()..strokeWidth = 1.25,
                  cornerSize: 5),
              child: SizedBox(
                width: 380,
                height: 380,
                child: InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image == null) {
                      return;
                    }
                    setState(() {
                      widget.imageController.changeImage(image);
                    });
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: _dragging
                          ? Border.all(color: Colors.orangeAccent, width: 2)
                          : null,
                      image: widget.imageController.hasImage()
                          ? DecorationImage(
                              image: widget.imageController.image!,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: !widget.imageController.hasImage()
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
                                  'Tap to upload an image',
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
            SizedBox(height: 32),
            if (sizes.length > 0) ...{
              Divider(),
              SizedBox(height: 16),
              Text(
                textService.getText(sizes.length > 1
                        ? 'uitext_varsize_header'
                        : 'uitext_fixedsize_header') +
                    (sizes.length > 1
                        ? ""
                        : textService.getText(sizes.first.getTextKey())),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            },
            if (sizes.length > 1) ...{
              SizedBox(height: 16),
              Text(locator<TextService>().getText('uitext_picksize_header')),
              SizedBox(height: 16),
              SegmentedButton<PersonSize>(
                multiSelectionEnabled: false,
                emptySelectionAllowed: true,
                segments: sizes
                    .map((size) => ButtonSegment(
                        value: size,
                        label: Text(textService.getText(size.getTextKey()))))
                    .toList(),
                selected: widget.upbringingController.selectedSize != null
                    ? {widget.upbringingController.selectedSize!}
                    : {},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    if (newSelection.isNotEmpty) {
                      widget.upbringingController.selectedSize =
                          newSelection.first;
                    }
                  });
                },
              )
            }
          ],
        ),
      ),
    );
  }
}

import 'package:EyuunApp/components/CharacterBase.dart';
import 'package:EyuunApp/view/popup/BuffDisplayPopup.dart';
import 'package:EyuunApp/view/popup/UpbringingPopup.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';
import '../popup/PopupUtil.dart';

class CharacterInfoWidget extends StatefulWidget {
  final ImageProvider profileImage;
  final Entity character;
  final String name;

  const CharacterInfoWidget(
      {super.key,
      required this.profileImage,
      required this.name,
      required this.character});

  @override
  State<CharacterInfoWidget> createState() => _CharacterInfoWidgetState();
}

class _CharacterInfoWidgetState extends State<CharacterInfoWidget> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adapt sizes based on available width
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;

    const double height = 150;
    const double padding = 6;

    const double textHeight = (height - padding * 2) / 3;
    final double fontSize = isCompact ? 14 : 16;

    var characterComponent = widget.character.get<CharacterBaseComponent>();

    var upbringingBuff = characterComponent?.upbringing.getEntity();
    var secondUpbringingBuff = characterComponent?.secondUpbringing.getEntity();
    var childhoodBuff = characterComponent?.childhood.getEntity();

    var textService = locator<TextService>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Profile image
            Container(
              width: height,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: widget.profileImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 📜 Right side info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1️⃣ Name (unchanged)
                  SizedBox(
                    height: textHeight,
                    child: Center(
                      child: TextField(
                        controller: _nameController,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // 2️⃣ Upbringing & Childhood (NEW split row)
                  SizedBox(
                    height: textHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              PopupUtil.popup(
                                context,
                                UpbringingPopup(primary: upbringingBuff, secondary: secondUpbringingBuff),
                                maximumSize: Size(1000, 600)
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Upbringing: ${textService.getTextFromEntity(upbringingBuff)}',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              PopupUtil.popup(
                                context,
                                BuffDisplayPopup(buff: childhoodBuff)
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Childhood: ${textService.getTextFromEntity(childhoodBuff)}',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // 3️⃣ Level & Origin (Ability → Origin)
                  SizedBox(
                    height: textHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              PopupUtil.popup(
                                context,
                                const Center(
                                  child: Text(
                                    'Popup explaining the next level-up.',
                                  ),
                                ),
                                maximumSize: const Size(300, 200),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withAlpha(150),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Level: ${characterComponent?.level}',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withAlpha(150),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Origin: ${characterComponent?.origin}',
                              style: TextStyle(
                                fontSize: fontSize - 2,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

  }
}

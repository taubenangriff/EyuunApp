import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/feature/LevelFeature.dart';
import 'package:eyuunapp/view/popup/BuffDisplayPopup.dart';
import 'package:eyuunapp/view/popup/LevelupPopup.dart';
import 'package:eyuunapp/view/popup/UpbringingPopup.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../popup/PopupUtil.dart';

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
    var secondUpbringingBuff = null;
    var childhoodBuff = characterComponent?.childhood.getEntity();

    var textService = locator<TextService>();
    var levelFeature = locator<LevelFeatureComponent>();

    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Profile image
            SizedBox(
              width: 200,
                child: AspectRatio(
              aspectRatio: 1, // 1:1
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: widget.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
            EyuunWidgets.spacerHorizontal(),

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
                  EyuunWidgets.spacerVertical(),

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
                                  UpbringingPopup(
                                      primary: upbringingBuff,
                                      secondary: secondUpbringingBuff),
                                  maximumSize: Size(
                                      characterComponent
                                                  ?.hasSecondaryUpbringing() ??
                                              true
                                          ? 1000
                                          : 500,
                                      600));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${textService.getText('uitext_upbringing')}${textService.getTextFromEntity(upbringingBuff)}${secondUpbringingBuff != null ? ", ${textService.getTextFromEntity(secondUpbringingBuff)}" : ""}',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        EyuunWidgets.spacerHorizontal(),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              PopupUtil.popup(context,
                                  BuffDisplayPopup(buff: childhoodBuff));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${textService.getText('uitext_childhood')}${textService.getTextFromEntity(childhoodBuff)}',
                                style: TextStyle(
                                  fontSize: fontSize - 2,
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
                  EyuunWidgets.spacerVertical(),
                  // 3️⃣ Level & Origin (Ability → Origin)
                  SizedBox(
                    height: textHeight,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              if (characterComponent == null) {
                                return;
                              }

                              var isMax = levelFeature
                                  .isMaxLevel(characterComponent.level);

                              if (isMax) {
                                PopupUtil.popup(
                                  context,
                                  const Center(
                                    child: Text(
                                      'You have reached the maximum level!',
                                    ),
                                  ),
                                  maximumSize: const Size(300, 200),
                                );
                                return;
                              }

                              var nextLevel = levelFeature
                                  .getLevelAsset(characterComponent.level + 1);

                              PopupUtil.popup(
                                  context, LevelupPopup(buff: nextLevel));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.cardColor,
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
                        EyuunWidgets.spacerHorizontal(),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
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

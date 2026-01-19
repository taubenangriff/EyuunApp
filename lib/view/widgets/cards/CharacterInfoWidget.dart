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

    var upbringingBuff = characterComponent?.upbringing;
    var secondUpbringingBuff = null;
    var childhoodBuff = characterComponent?.childhood;

    var textService = locator<TextService>();
    var levelFeature = locator<LevelFeatureComponent>();

    var theme = Theme.of(context);

    Widget _infoTile({
      required String text,
      bool bold = false,
    }) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize - 2,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    List<Widget> characterWidgets = [
      InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            PopupUtil.popup(
              context,
              UpbringingPopup(
                primary: upbringingBuff,
                secondary: secondUpbringingBuff,
              ),
            );
          },
          child: _infoTile(
            text:
                '${textService.getText('uitext_upbringing')}${textService.getTextFromEntity(upbringingBuff)}'
                '${secondUpbringingBuff != null ? ", ${textService.getTextFromEntity(secondUpbringingBuff)}" : ""}',
          )),
      InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            PopupUtil.popup(
              context,
              BuffDisplayPopup(buff: childhoodBuff),
            );
          },
          child: _infoTile(
            text:
                '${textService.getText('uitext_childhood')}${textService.getTextFromEntity(childhoodBuff)}',
          )),
      InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          if (characterComponent == null) return;

          if (levelFeature.isMaxLevel(characterComponent.level)) {
            PopupUtil.popup(
              context,
              const Center(child: Text('You have reached the maximum level!')),
              maximumSize: const Size(300, 200),
            );
            return;
          }

          final nextLevel =
              levelFeature.getLevelAsset(characterComponent.level + 1);

          PopupUtil.popup(
            context,
            LevelupPopup(buff: nextLevel),
          );
        },
        child: _infoTile(
          text: 'Level: ${characterComponent?.level}',
          bold: true,
        ),
      ),
      _infoTile(
        text: 'Origin: ${characterComponent?.origin}',
        bold: true,
      )
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🖼️ Profile image
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180),
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
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
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
                        EyuunWidgets.spacerVertical(),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent:
                                        420, // controls when it becomes 1 vs 2 columns
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    mainAxisExtent: 60),
                            itemCount: characterWidgets.length,
                            itemBuilder: (context, index) =>
                                characterWidgets[index])
                      ]))
            ]);
      },
    );
  }
}

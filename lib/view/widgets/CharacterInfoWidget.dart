import 'package:flutter/material.dart';

import '../popup/PopupUtil.dart';

class CharacterInfoWidget extends StatefulWidget {
  final ImageProvider profileImage;
  final String name;
  final String upbringing;
  final String childhood;
  final String origin;
  final int level;

  const CharacterInfoWidget(
      {super.key,
      required this.profileImage,
      required this.name,
      required this.upbringing,
      required this.childhood,
      required this.origin,
      required this.level});

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
                                const Center(
                                  child: Text(
                                    'Popup describing upbringing buffs and effects.',
                                  ),
                                ),
                                maximumSize: const Size(300, 200),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Upbringing: ${widget.upbringing}',
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
                                const Center(
                                  child: Text(
                                    'Popup describing childhood buffs and effects.',
                                  ),
                                ),
                                maximumSize: const Size(300, 200),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Childhood: ${widget.childhood}',
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
                                'Level: ${widget.level}',
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
                              'Origin: ${widget.origin}',
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

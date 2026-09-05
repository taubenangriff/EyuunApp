import 'package:eyuunapp/model/CharacterMetaInfo.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/CreateCharacterPage.dart';
import 'package:eyuunapp/view/popup/ConfirmDeletePopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class SessionCharacter {
  final String sessionId;
  final CharacterMetaInfo metaInfo;

  const SessionCharacter(this.sessionId, this.metaInfo);
}

class CharacterSelectionPage extends StatefulWidget {
  final List<SessionCharacter> characterList;

  const CharacterSelectionPage({
    super.key,
    required this.characterList,
  });

  @override
  State<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  final double desiredSize = 1100;

  @override
  Widget build(BuildContext context) {
    final characters = widget.characterList;

    return Scaffold(
        appBar: AppBar(title: const Text('Select Character')),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('data/base/ui/bg/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: characters.isEmpty
                    ? const Center(child: Text('No characters found.'))
                    : GridView.builder(
                        itemCount: characters.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.55,
                          maxCrossAxisExtent: 300,
                        ),
                        itemBuilder: (context, index) {
                          final character = characters[index];
                          return _CharacterCard(
                            character: character.metaInfo,
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const LoadingPage()));
                              await locator<SessionService>()
                                  .loadSession(character.sessionId);

                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      character.metaInfo.characterState ==
                                              CharacterState.InCreation
                                          ? const CreateCharacterPage(
                                              title: 'Create a new Character',
                                            )
                                          : const MainPage(title: 'Eyuun App'),
                                ),
                              );
                            },
                            onDelete: () async {
                              final confirmed = await PopupUtil.popup<bool>(
                                context,
                                ConfirmDeletePopup(
                                  characterName: character.metaInfo.name,
                                ),
                              );

                              if (confirmed == true) {
                                locator<DatabaseAccess>()
                                    .deleteSession(character.sessionId);
                                setState(() {
                                  widget.characterList.remove(character);
                                });
                              }
                            },
                          );
                        },
                      ),
              )),
        ));
  }
}

class _CharacterCard extends StatelessWidget {
  final CharacterMetaInfo character;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CharacterCard({
    required this.character,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late final ImageProvider<Object> portraitImage;
    if (character.image == null) {
      portraitImage = const AssetImage('data/base/ui/bg/background.jpg');
    } else {
      portraitImage = NetworkImage(character.image.toString());
    }

    return Card(
        elevation: 8,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: ArtDecoBoxDecoration(
              cornerBuilder: (p) => DoubleLineCornerPainter(p),
              verticalLineBuilder: (p) => DoubleLinePainter(p),
              horizontalLineBuilder: (p) => DoubleLinePainter(p),
              paint: Brushes.goldSparkling()..strokeWidth = 1.25,
              cornerSize: 20),
          child: Stack(
            children: [
              InkWell(
                onTap: onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🖼 Image (1x1)
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image(
                        image: portraitImage,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // 📜 Info
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            character.name,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Upbringing: ${character.upbringing}'),
                          Text('Level ${character.level}'),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // 📜 Info
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modified: ${character.lastModified}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            'Creator: ${character.creatorName}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (character.characterState == CharacterState.InCreation)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber, width: 1),
                    ),
                    child: const Text(
                      'In Creation',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    tooltip: 'Delete Character',
                    onPressed: onDelete,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

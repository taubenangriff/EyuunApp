import 'package:eyuunapp/model/CharacterMetaInfo.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/CreateCharacterPage.dart';
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class _SessionCharacter {
  final String sessionId;
  final CharacterMetaInfo metaInfo;

  const _SessionCharacter(this.sessionId, this.metaInfo);
}

class CharacterSelectionPage extends StatefulWidget {
  const CharacterSelectionPage({super.key});

  @override
  State<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  final double desiredSize = 1100;
  late final Future<List<_SessionCharacter>> _characters;

  @override
  void initState() {
    super.initState();
    _characters = _loadCharacters();
  }

  Future<List<_SessionCharacter>> _loadCharacters() async {
    final databaseAccess = locator<DatabaseAccess>();
    final sessionIds = await databaseAccess.getSessionKeys();
    final characters = await Future.wait(
      sessionIds.map((sessionId) async {
        final metaInfo = await databaseAccess.getCharacterMetaInfo(sessionId);
        return metaInfo == null ? null : _SessionCharacter(sessionId, metaInfo);
      }),
    );
    return characters.whereType<_SessionCharacter>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_SessionCharacter>>(
      future: _characters,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Could not load characters.')),
          );
        }
        if (!snapshot.hasData) {
          return const LoadingPage();
        }

        return _buildCharacterSelection(context, snapshot.data!);
      },
    );
  }

  Widget _buildCharacterSelection(
    BuildContext context,
    List<_SessionCharacter> characters,
  ) {
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

  const _CharacterCard({
    required this.character,
    required this.onTap,
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
          child: InkWell(
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
                Spacer(),
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
        ));
  }
}

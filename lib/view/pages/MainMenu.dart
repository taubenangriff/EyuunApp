import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/CharacterSelectionPage.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/pages/CreateCharacterPage.dart';
import 'package:eyuunapp/view/pages/MainPage.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late Future<List<SessionCharacter>> _characters;

  @override
  void initState() {
    super.initState();
    _reloadCharacters();
  }

  void _reloadCharacters() {
    _characters = _loadCharacters();
  }

  Future<List<SessionCharacter>> _loadCharacters() async {
    final databaseAccess = locator<DatabaseAccess>();
    final sessionIds = await databaseAccess.getSessionKeys();
    final characters = await Future.wait(
      sessionIds.map((sessionId) async {
        final metaInfo = await databaseAccess.getCharacterMetaInfo(sessionId);
        return metaInfo == null ? null : SessionCharacter(sessionId, metaInfo);
      }),
    );
    final validCharacters = characters.whereType<SessionCharacter>().toList();
    validCharacters.sort(
        (a, b) => b.metaInfo.lastModified.compareTo(a.metaInfo.lastModified));
    return validCharacters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('data/base/ui/bg/mainmenu.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:
              // ⬅ Left menu
              Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List<SessionCharacter>>(
                  future: _characters,
                  builder: (context, snapshot) {
                    final characters = snapshot.data ?? [];
                    if (characters.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final lastCharacter = characters.first;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EyuunWidgets.floatingActionButton(
                          text: 'Load ${lastCharacter.metaInfo.name}',
                          width: 300,
                          height: 50,
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const LoadingPage()));

                            await locator<SessionService>()
                                .loadSession(lastCharacter.sessionId);

                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) =>
                                    lastCharacter.metaInfo.characterState ==
                                            CharacterState.InCreation
                                        ? const CreateCharacterPage(
                                            title: 'Create a new Character',
                                          )
                                        : const MainPage(title: 'Eyuun App'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 64),
                        EyuunWidgets.floatingActionButton(
                          text: 'Load Character',
                          width: 300,
                          height: 50,
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CharacterSelectionPage(
                                  characterList: characters,
                                ),
                              ),
                            );
                            if (!context.mounted) return;
                            setState(_reloadCharacters);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                EyuunWidgets.floatingActionButton(
                  text: 'Create Character',
                  width: 300,
                  height: 50,
                  onPressed: () async {
                    locator<SessionService>().createNewSession();

                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateCharacterPage(
                            title: 'Create a new Character'),
                      ),
                    );
                    if (!context.mounted) return;
                    setState(_reloadCharacters);
                  },
                ),
                const SizedBox(height: 16),
                EyuunWidgets.floatingActionButton(
                  text: 'Groups',
                  width: 300,
                  height: 50,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                EyuunWidgets.floatingActionButton(
                  text: 'Options',
                  width: 300,
                  height: 50,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

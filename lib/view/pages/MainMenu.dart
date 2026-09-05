import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/CharacterSelectionPage.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuuncore/GetIt.dart';
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
  late Future<List<String>> _sessionKeys;

  @override
  void initState() {
    super.initState();
    _reloadSessionKeys();
  }

  void _reloadSessionKeys() {
    _sessionKeys = locator<DatabaseAccess>().getSessionKeys();
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
                FutureBuilder<List<String>>(
                  future: _sessionKeys,
                  builder: (context, snapshot) {
                    if (snapshot.data?.isEmpty ?? true) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EyuunWidgets.floatingActionButton(
                          text: 'Load <Last Character>',
                          width: 300,
                          height: 50,
                          onPressed: () async {
                            final lastSessionKey =
                                await locator<DatabaseAccess>()
                                    .getLastSession();
                            if (!context.mounted || lastSessionKey == null) {
                              return;
                            }

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const LoadingPage()));

                            await locator<SessionService>()
                                .loadSession(lastSessionKey);

                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const MainPage(title: 'Eyuun App'),
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
                                builder: (_) => const CharacterSelectionPage(),
                              ),
                            );
                            if (!context.mounted) return;
                            setState(_reloadSessionKeys);
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
                    setState(_reloadSessionKeys);
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

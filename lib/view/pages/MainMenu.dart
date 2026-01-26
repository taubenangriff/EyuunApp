import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/CharacterSelectionPage.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/pages/CreateCharacterPage.dart';
import 'package:eyuunapp/view/pages/MainPage.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('data/base/ui/bg/background.jpg'),
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
                EyuunWidgets.floatingActionButton(
                  text: 'Load <Last Character>',
                  width: 300,
                  height: 50,
                  onPressed: () async {
                    if(!context.mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoadingPage()));

                    await locator<SessionService>().loadSession("fuck");

                    if(!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const MainPage(title: 'Eyuun App'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 64),
                EyuunWidgets.floatingActionButton(
                  text: 'Load Character',
                  width: 300,
                  height: 50,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CharacterSelectionPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                EyuunWidgets.floatingActionButton(
                  text: 'Create Character',
                  width: 300,
                  height: 50,
                  onPressed: () {
                    locator<SessionService>().createNewSession();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CreateCharacterPage(
                          title: 'Create a new Character'
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                EyuunWidgets.floatingActionButton(
                  text: 'Groups',
                  width: 300,
                  height: 50,
                  onPressed: () { },
                ),
                const SizedBox(height: 16),
                EyuunWidgets.floatingActionButton(
                  text: 'Options',
                  width: 300,
                  height: 50,
                  onPressed: () { },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 240,
      child: Card(
        elevation: 12,
        color: Colors.black.withOpacity(0.65),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 24,
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

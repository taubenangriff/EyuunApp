import 'dart:async';

import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/CharacterSelectionPage.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<List<String>>? _sessionKeys;
  late final StreamSubscription<User?> _authSubscription;
  User? _user;
  var _authResolved = false;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (!mounted) return;
        setState(() {
          _user = user;
          _authResolved = true;
          _sessionKeys =
              user == null ? null : locator<DatabaseAccess>().getSessionKeys();
        });
      },
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    } on FirebaseAuthException catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google sign-in failed (${exception.code}): '
            '${exception.message ?? 'Unknown Firebase error.'}',
          ),
        ),
      );
    } catch (exception, stackTrace) {
      debugPrint('Google sign-in failed: $exception\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in could not be started.')),
      );
    }
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
                if (!_authResolved)
                  const SizedBox(
                    width: 300,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_user == null)
                  EyuunWidgets.floatingActionButton(
                    text: 'Sign in with Google',
                    icon: Icons.login,
                    width: 300,
                    height: 50,
                    onPressed: _signInWithGoogle,
                  )
                else ...[
                  Text(_user!.email ?? 'Signed in with Google'),
                  const SizedBox(height: 16),
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
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CharacterSelectionPage(),
                                ),
                              );
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
                    onPressed: () {
                      locator<SessionService>().createNewSession();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreateCharacterPage(
                              title: 'Create a new Character'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  EyuunWidgets.floatingActionButton(
                    text: 'Sign Out',
                    icon: Icons.logout,
                    width: 300,
                    height: 50,
                    onPressed: FirebaseAuth.instance.signOut,
                  ),
                ],
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

import 'package:eyuunapp/view/pages/MainMenu.dart';
import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);
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
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }
        if (snapshot.hasData) return const MainMenu();

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('data/base/ui/bg/mainmenu.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: EyuunWidgets.floatingActionButton(
              text: 'Log in with Google',
              height: 32,
              width: 160,
              onPressed: _isSigningIn ? null : _signInWithGoogle,
            )),
          ),
        );
      },
    );
  }
}

import 'package:eyuunapp/view/pages/LoadingPage.dart';
import 'package:eyuunapp/view/pages/MainPage.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final Future<void> Function() onCharacterCreated;

  const SummaryPage({super.key, required this.onCharacterCreated});

  Future<void> _createCharacter(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoadingPage()),
    );
    await onCharacterCreated();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainPage(title: 'Eyuun App')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EyuunWidgets.floatingActionButton(
        text: 'Create',
        width: 300,
        height: 50,
        onPressed: () => _createCharacter(context),
      ),
    );
  }
}

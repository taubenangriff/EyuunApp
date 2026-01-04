import 'package:flutter/material.dart';

import '../view/MainPage.dart';

void main() {
  runApp(EditorWindow());
}

class EditorWindow extends StatelessWidget {
  const EditorWindow({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyuun Asset Editor',
      home: const MainPage(title: 'Eyuun App ECS Demo'),
    );
  }
}

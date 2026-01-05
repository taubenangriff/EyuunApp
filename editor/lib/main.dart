import 'package:editor/views/Editor.dart';
import 'package:eyuuncore/core/reflection/reflector.reflectable.dart';
import 'package:eyuuncore/core/registerComponentsExtension.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';
import 'package:flutter/material.dart';

var componentRepo = ComponentRepository();

void main() {
  componentRepo.registerComponents();
  initializeReflectable();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Editor(),
    );
  }
}
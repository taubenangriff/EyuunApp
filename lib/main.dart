import 'package:flexbackend/components/Attributes.dart';
import 'package:flexbackend/components/health.dart';
import 'package:flexbackend/components/standard.dart';
import 'package:flexbackend/controller/BasicStatsController.dart';
import 'package:flexbackend/io/AssetSerializer.dart';
import 'package:flexbackend/core/registerComponentsExtension.dart';
import 'package:flexbackend/core/registerSystemsExtension.dart';
import 'package:flexbackend/core/registerUpgradesExtension.dart';
import 'package:flexbackend/core/services/WorldManager.dart';
import 'package:flexbackend/core/registerServices.dart';
import 'package:flexbackend/view/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'dart:convert';

import 'core/repository/TextRepository.dart';
import 'core/services/CharacterService.dart';
import 'core/services/TextService.dart';
import 'core/services/assetloader.dart';

late Entity character;

String textFile = "data/base/text/de_de.json";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();

  var worldManager = locator<WorldManager>();

  worldManager.registerComponents();
  worldManager.registerSystems();
  worldManager.registerUpgrades();
  worldManager.init();

  var assetLoader = locator<AssetLoader>();

  await assetLoader.reloadAssets();
  await locator<TextRepository>().reloadTexts(textFile);
  character = assetLoader.createInstance("character")!;
  locator<CharacterService>().changeCharacter(character);

  worldManager.world.execute(1);

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
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF90A4AE), // Blue-grey 300
          onPrimary: Colors.black,
          secondary: const Color(0xFFf8a763), // Gold accent
          onSecondary: Colors.black,
          surface: const Color(0xFF263238), // Dark blue-grey
          onSurface: Colors.white,
          background: const Color(0xFF212121), // Dark background
          onBackground: Colors.white,
          error: Colors.red.shade400,
          onError: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFF212121),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF37474F), // Blue-grey 800
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFf8a763), // Gold
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF90A4AE), // Blue-grey 300
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF90A4AE)),
      ),
      home: const MainPage(title: 'Eyuun App ECS Demo'),
    );
  }
}

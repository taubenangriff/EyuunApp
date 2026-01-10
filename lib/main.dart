import 'dart:math';

import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/core/objectLink.dart';
import 'package:eyuuncore/core/registerFeatures.dart';
import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/registerComponentsExtension.dart';
import 'package:eyuuncore/core/registerSystemsExtension.dart';
import 'package:eyuuncore/core/registerUpgradesExtension.dart';
import 'package:eyuuncore/core/repository/TextRepository.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/LoadDataService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:EyuunApp/view/MainPage.dart';
import 'package:eyuuncore/io/GameObjectsExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

String textFile = "data/base/text/de_de.json";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

  var worldManager = locator<WorldManager>();

  worldManager.registerComponents();
  worldManager.registerSystems();
  worldManager.registerUpgrades();
  worldManager.init();

  await locator<AssetDataRepository>().reloadAssetFile();

  var loadDataService = locator<LoadDataService>();
  await loadDataService.reloadAssets();
  await locator<TextRepository>().reloadTexts(textFile);

  registerFeatures();

  var goService = locator<GameObjectService>();

  final String response = await rootBundle.loadString("data/base/char.json");
  var gameObjects = GameObjectsExportMapper.fromJson(response);
  goService.loadEntities(gameObjects);

  var character = goService.getObject("8c325009-b118-4872-9464-b2279e8e1307");

  if(character == null){
    return;
  }

  var weapon = goService.createInstance("smite_weapon_axe");
  if(weapon != null){
    character.get<CombatComponent>()?.equippedItems.add(ObjectLink.fromEntity(weapon));
  }

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
          surface: const Color(0xff1e1e1e), // Dark blue-grey
          onSurface: Colors.white,
          background: const Color(0xff333333), // Dark background
          onBackground: Colors.white,
          error: Colors.red.shade400,
          onError: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xff333333),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff1e1e1e), // Blue-grey 800
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(

          backgroundColor: Color(0xff1e1e1e), // Gold
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

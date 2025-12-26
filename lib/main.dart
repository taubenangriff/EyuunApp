import 'dart:collection';
import 'dart:math';

import 'package:EyuunApp/components/Attributes.dart';
import 'package:EyuunApp/components/health.dart';
import 'package:EyuunApp/core/UpgradableInt.dart';
import 'package:EyuunApp/core/components/standard.dart';
import 'package:EyuunApp/controller/AttributesController.dart';
import 'package:EyuunApp/core/repository/AssetRepository.dart';
import 'package:EyuunApp/io/AssetSerializer.dart';
import 'package:EyuunApp/core/registerComponentsExtension.dart';
import 'package:EyuunApp/core/registerSystemsExtension.dart';
import 'package:EyuunApp/core/registerUpgradesExtension.dart';
import 'package:EyuunApp/core/services/WorldManager.dart';
import 'package:EyuunApp/core/registerServices.dart';
import 'package:EyuunApp/view/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'dart:convert';

import 'components/Flux.dart';
import 'components/inventory.dart';
import 'core/assetLink.dart';
import 'core/repository/TextRepository.dart';
import 'core/services/CharacterService.dart';
import 'core/services/TextService.dart';
import 'core/services/assetloader.dart';

import 'package:dart_mappable/dart_mappable.dart';

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

  await locator<AssetRepository>().reloadAssetFile();

  var assetLoader = locator<AssetLoader>();
  await assetLoader.reloadAssets();

  await locator<TextRepository>().reloadTexts(textFile);
  character = assetLoader.createInstance("character")!;
  locator<CharacterService>().changeCharacter(character);

  worldManager.world.execute(1);

  fillTestData();

  runApp(const MyApp());
}

void fillTestData()
{
  //Fill Characters inventory with bullshit
  var random = Random();
  List<InventoryItem> inventoryItems = List.generate(
      15,
          (index) => InventoryItem(AssetLink("item_dummy1"), count: random.nextInt(10) + 1));

  var char = locator<CharacterService>().character;

  char.get<InventoryComponent>()?.addAll(inventoryItems);
  char.get<FluxComponent>()?.fluxMaximum = 15.upgradable;
  char.get<FluxComponent>()?.fluxSpent = 2;
  char.get<FluxComponent>()?.fluxCapacity = 12.upgradable;
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

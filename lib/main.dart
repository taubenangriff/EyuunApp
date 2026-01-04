import 'dart:math';

import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/registerFeatures.dart';
import 'package:eyuuncore/core/repository/AssetRepository.dart';
import 'package:eyuuncore/core/registerComponentsExtension.dart';
import 'package:eyuuncore/core/registerSystemsExtension.dart';
import 'package:eyuuncore/core/registerUpgradesExtension.dart';
import 'package:eyuuncore/core/repository/TextRepository.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:EyuunApp/view/MainPage.dart';
import 'package:eyuuncore/core/services/assetloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxygen/oxygen.dart';

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

  await locator<AssetRepository>().reloadAssetFile();

  var assetLoader = locator<AssetLoader>();
  await assetLoader.reloadAssets();
  await locator<TextRepository>().reloadTexts(textFile);

  registerFeatures();

  var character = assetLoader.createInstance("character")!;
  locator<CharacterService>().changeCharacter(character);

  await fillTestData();
  worldManager.world.execute(1);

  runApp(const MyApp());
}

Future fillTestData() async
{
  //Fill Characters inventory with bullshit
  var random = Random();
  List<InventoryItem> inventoryItems = List.generate(
      15,
          (index) => InventoryItem(AssetLink("item_dummy1"), count: random.nextInt(10) + 1));

  var char = locator<CharacterService>().character;

  final String response = await rootBundle.loadString("data/base/char.json");
  var chardata = json.decode(response);
  locator<AssetLoader>().applyDynamicData(char, chardata);
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

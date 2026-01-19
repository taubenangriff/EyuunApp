import 'dart:math';

import 'package:eyuunapp/view/widgets/eyuun/EyuunUiImageProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';


import 'package:eyuunapp/view/pages/MainMenu.dart';
import 'package:eyuunapp/view/pages/MainPage.dart';
import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/core/assetLink.dart';
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
import 'package:eyuuncore/io/GameObjectsExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String textFile = "data/base/text/de_de.json";


void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

  locator.registerLazySingleton(() => EyuunUiImagerProvider());
  await locator<EyuunUiImagerProvider>().preloadImage("data/base/ui/bg/artdecocorner.png");

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
  goService.registerEntities(gameObjects);
  goService.loadEntitiesData(gameObjects);
  var character = goService.getObject(gameObjects.characterId);

  if(character == null){
    return;
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
        fontFamily: GoogleFonts.eagleLake().fontFamily,
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
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 12),
          titleLarge: TextStyle(color: Colors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF90A4AE)),
      ),
      home: const MainMenu(),
    );
  }
}

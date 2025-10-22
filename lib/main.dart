import 'package:flexbackend/components/BasicStats.dart';
import 'package:flexbackend/components/health.dart';
import 'package:flexbackend/components/standard.dart';
import 'package:flexbackend/controller/BasicStatsController.dart';
import 'package:flexbackend/io/AssetSerializer.dart';
import 'package:flexbackend/io/registerComponentsExtension.dart';
import 'package:flexbackend/io/registerSystemsExtension.dart';
import 'package:flexbackend/io/registerUpgradesExtension.dart';
import 'package:flexbackend/core/WorldManager.dart';
import 'package:flexbackend/view/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'dart:convert';

import 'dart:html' as html;

import 'components/healthUpgrade.dart';
import 'core/TextHelper.dart';
import 'core/assetloader.dart';

late Entity character;

//Some code to just download the character as json
void downloadConfig(String data) {
  final blob = html.Blob([data]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'config.json')
    ..click();
  html.Url.revokeObjectUrl(url);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WorldManager.instance.registerComponents();
  WorldManager.instance.registerSystems();
  WorldManager.instance.registerUpgrades();
  WorldManager.instance.init();

  await AssetLoader.instance.reloadAssets();

  character = AssetLoader.instance.createInstance("character")!;

  WorldManager.instance.world.execute(1);

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BasicStatsController statsController =
      BasicStatsController(WorldManager.instance, AssetLoader.instance);

  void _downloadChar() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      var charJson = json.encode(AssetSerializer().serialize(character));
      downloadConfig(charJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    var stats = character.get<BasicStatsComponent>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(200),
                1: FixedColumnWidth(200),
                2: FixedColumnWidth(200)
              },
              children: stats.statValues.map((entry) {
                return TableRow(children: [
                  Text(TextHelper.getText(entry.stat)),
                  Text(entry.dice.toString()),
                  FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          statsController.increaseDice(character, entry.stat);
                        });
                      },
                      child: Text(TextHelper.getText("text_increase")))
                ]);
              }).toList(),
            ),
            Text(
                "Health:  ${character.get<HealthComponent>()?.hitpoints}/${character.get<HealthComponent>()?.maxHitpoints.current}")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadChar,
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

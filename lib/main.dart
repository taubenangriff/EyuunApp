import 'package:flexbackend/components/BasicStats.dart';
import 'package:flexbackend/components/health.dart';
import 'package:flexbackend/components/standard.dart';
import 'package:flexbackend/controller/BasicStatsController.dart';
import 'package:flexbackend/io/AssetSerializer.dart';
import 'package:flexbackend/io/TextRepository.dart';
import 'package:flexbackend/io/WorldManager.dart';
import 'package:flexbackend/io/assetloader.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'dart:convert';
import 'main.reflectable.dart';
import 'package:flexbackend/reflection/Reflector.dart';

import 'dart:html' as html;

const reflector = Reflector();

final TextRepository texts = TextRepository();

final world = World();
late final WorldManager worldManager;
late final AssetLoader assetLoader;

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

void main() {
  initializeReflectable();


  worldManager = WorldManager(world);
  worldManager.registerComponent<StandardComponent, String>(StandardComponent.propertyName, () => StandardComponent());
  worldManager.registerComponent<HealthComponent, int>(HealthComponent.propertyName, () => HealthComponent());
  worldManager.registerComponent<BasicStatsComponent, int>(BasicStatsComponent.propertyName, () => BasicStatsComponent());
  world.init();

  assetLoader = AssetLoader(worldManager);
  character = assetLoader.createTestEntity("testObject", "type");

  Entity? ente = null;

  Future(() async {
    await assetLoader.reloadAssets();
    ente = assetLoader.createInstance('character');
  });

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Eyuun App ECS Demo'),
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

  BasicStatsController statsController = BasicStatsController(worldManager, assetLoader);

  void _downloadChar() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      var charJson = json.encode(AssetSerializer(worldManager).serialize(character));
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
                  //TODO get asset from key -> get text of that asset
                  Text(TextRepository.instance.getText(assetLoader.getTextKey(entry.stat))),
                  Text(entry.dice.toString()),
                  FloatingActionButton(onPressed: () {
                    setState(() {
                      statsController.increaseDice(character, entry.stat);
                    });
                  },
                  child: Text("increase (mod15)"),)
                ]);
              }).toList(),
            )
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

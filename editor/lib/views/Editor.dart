import 'dart:convert';
import 'dart:io';

import 'package:editor/io/AssetExporter.dart';
import 'package:editor/io/StaticAssetLoader.dart';
import 'package:editor/main.dart';
import 'package:editor/views/AssetWidget.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../Asset.dart';
import 'SelectFile.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String selectedAsset = "";
  File? assetFile;

  Asset? loadedAsset = null;

  var assetloader = StaticAssetLoader(componentRepo);
  late var assetexporter = AssetExporter(componentRepo, assetloader);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            child: SelectFileWidget(
              onFileSelected: (file) async {
                setState(() {
                  assetFile = file;
                });

                if (assetFile == null) {
                  return;
                }
                var json = await loadJsonFile(assetFile!);
                loadedAsset = assetloader.loadAsset(json);
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: loadedAsset != null
                ? AssetWidget(asset: loadedAsset!)
                : Center(child: Text("No asset selected")),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 128,
        child: FloatingActionButton(
          onPressed: () {
            var dir = Directory(join(Directory.current.path, 'assetdata'));
            assetexporter.export(dir, Directory.current.parent);
            // export
          },
          tooltip: "Export assets",
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.save), SizedBox(width: 8), Text("Export")],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> loadJsonFile(File file) async {
    final String contents = await file.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(contents);
    return jsonMap;
  }
}

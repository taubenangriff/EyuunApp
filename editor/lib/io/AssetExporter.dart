import 'dart:convert';
import 'dart:io';

import 'package:editor/io/StaticAssetLoader.dart';
import 'package:editor/main.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';
import 'package:path/path.dart';

import '../Asset.dart';
import 'AssetFile.dart';


class AssetExporter {

  String exportRoot = "data\\base\\asset\\";

  ComponentRepository componentRepository;
  StaticAssetLoader staticAssetLoader;

  AssetExporter(this.componentRepository, this.staticAssetLoader);

  void export(Directory srcDir, Directory outputDirectory) {
    outputDirectory.deleteSync(recursive: true);
    outputDirectory.createSync();
    _processDirectory(srcDir, outputDirectory, srcDir);
  }

  void _processDirectory(Directory dir, Directory outputDirectory, Directory rootDir) {

    outputDirectory.createSync();

    var assetfile = AssetFile([], []);

    var entries = dir.listSync(followLinks: false);

    var subDirectories = entries.whereType<Directory>();
    var files = entries.whereType<File>();

    for(var file in files) {
      var data = file.readAsStringSync();

      try {
        var assetData = jsonDecode(data);
        var loaded = staticAssetLoader.loadAsset(assetData);
        var remapped = staticAssetLoader.toMap(loaded);
        assetfile.assets.add(remapped);

      } on Exception catch (exception) {
        print("asset at ${file.path} contains invalid data and is as such not exported.");
        print(exception);
      }

    }

    for(var subDirectory in subDirectories) {
      var relPath = relative(subDirectory.path, from: rootDir.path);
      var includePath = "$exportRoot$relPath.json";
      includePath = includePath.replaceAll("\\", "/");
      assetfile.include.add(includePath);

      _processDirectory(subDirectory, outputDirectory, rootDir);
    }

    var assetfileData = jsonEncode(assetfile.toMap());

    var relPathOfThis = relative(dir.path, from: rootDir.path);

    var isRoot = relPathOfThis == ".";

    if(isRoot) {
      relPathOfThis = "assets";
    }

    var targetFile = File("${outputDirectory.path}\\$exportRoot\\$relPathOfThis.json");
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsStringSync(assetfileData);
  }

  Map<String, dynamic> toJsonMap(Asset asset) {
    var map = <String, dynamic>{};

    for(var entry in asset.components.entries) {

      if(!componentRepository.isComponent(entry.key)) {
        continue;
      }

      var submap = componentRepository.toMap(entry.value);

      map[entry.key] = submap;
    }

    return map;
  }

  String toJson(Map<String, dynamic> jsonMap) {
    return json.encode(jsonMap);
  }
}
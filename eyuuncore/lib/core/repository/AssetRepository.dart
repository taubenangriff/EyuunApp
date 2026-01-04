import 'dart:convert';

import 'package:flutter/services.dart';

String assetFile = "data/base/asset/assets.json";

class AssetRepository {
  Map<String, Map<String, dynamic>> assets = {};

  Map<String, dynamic>? getAssetMap(String typeId) =>
      assets.containsKey(typeId) ? assets[typeId] : null;

  Iterable<Map<String, dynamic>> getAssetMaps() => assets.values;

  bool isValidDefinition(String typeId) {
    if (!assets.containsKey(typeId)) {
      return false;
    }
    return true;
  }

  Future<void> reloadAssetFile() async {
    assets.clear();
    return addAssetsFromFile(assetFile);
  }

  Future<void> addAssetsFromFile(String file) async {
    final String response = await rootBundle.loadString(file);
    var data = json.decode(response);
    var includes = data['include'];

    if (includes != null) {
      for (var include in includes) {
        if (include is! String) {
          continue;
        }
        await addAssetsFromFile(include);
      }
    }

    var assetArray = data['assets'];
    for (var asset in assetArray) {
      addAsset(asset);
    }
  }

  void addAsset(dynamic asset) {
    //we want var typeId = asset['standard']['typeId'] but in safe.
    var typeId = asset['standard']['typeId'] as String?;
    if (typeId == null) {
      return;
    }
    //register asset
    assets[typeId] = asset as Map<String, dynamic>;
  }
}

import 'dart:io';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:flutter/material.dart';

part 'Icon.mapper.dart';

@MappableClass()
@reflector
class IconStatic with IconStaticMappable, ComponentReflectable {
  String iconFilepath;

  IconStatic(this.iconFilepath);
}

class IconComponent extends EyuunComponent<int> {
  static const String propertyName = "icon";

  String iconFilepath = "";

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = IconStaticMapper.fromMap(staticData);
    iconFilepath = stat.iconFilepath;
  }

  @override
  void reset() {

  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
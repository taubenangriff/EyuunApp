import 'package:oxygen/oxygen.dart';

import 'EyuunComponent.dart';

class StandardComponent extends EyuunComponent<String> {
  late final String objectId;
  late final String typeId;

  static String propertyName = "standard";

  String? internalName;
  String? comment;

  @override
  void init([String? objectId]) {
    if(objectId == null) {
      throw ArgumentError("Cannot initialize a Standard component with Null ID");
    }
    this.objectId = objectId!;
  }

  @override
  void reset() {
    objectId = "";
  }

  @override
  Map<String, dynamic> persist() {
    return {
      'objectId': objectId,
      'typeId': typeId
    };
  }

  @override
  void applyValues(Map<String, dynamic> valueMap){
    objectId = valueMap['objectId'];
    typeId = valueMap['typeId'];
  }

  @override
  String getName() => propertyName;
}
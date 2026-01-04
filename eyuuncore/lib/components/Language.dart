import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';

part 'Language.mapper.dart';

@MappableClass()
class LanguageStatic with LanguageStaticMappable {
  bool written;
  bool spoken;
  bool alternativeCommunicationStyle;

  LanguageStatic(this.written, this.spoken, this.alternativeCommunicationStyle);
}

class LanguageComponent extends EyuunComponent<int> {
  static const String propertyName = "language";

  late bool written;
  late bool spoken;
  late bool alternativeCommunicationStyle;

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
    var stat = LanguageStaticMapper.fromMap(staticData);
    written = stat.written;
    spoken = stat.spoken;
    alternativeCommunicationStyle = stat.alternativeCommunicationStyle;
  }

  @override
  void reset() {
    written = false;
    spoken = false;
    alternativeCommunicationStyle = false;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
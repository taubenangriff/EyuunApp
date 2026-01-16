import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/enums/PersonSize.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Upbringing.mapper.dart';

@MappableClass()
@reflector
class UpbringingStatic with UpbringingStaticMappable, ComponentReflectable {
  List<PersonSize> possibleSizes;
  UpbringingStatic(List<PersonSize>? possibleSizes) : possibleSizes = possibleSizes ?? [];
}

class UpbringingComponent extends EyuunComponent<int> {
  static const String propertyName = "upbringing";

  late List<PersonSize> possibleSizes;

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
    var stat = UpbringingStaticMapper.fromMap(staticData);
    possibleSizes = stat.possibleSizes;
  }

  @override
  void reset() {
    possibleSizes = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
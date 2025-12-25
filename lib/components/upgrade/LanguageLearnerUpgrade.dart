import 'package:dart_mappable/dart_mappable.dart';
import '../../core/components/EyuunComponent.dart';

part 'LanguageLearnerUpgrade.mapper.dart';

@MappableClass()
class LanguageLearnerUpgradeStatDyn with LanguageLearnerUpgradeStatDynMappable {
  int languageMaxPotentialUpgrade;
  LanguageLearnerUpgradeStatDyn([this.languageMaxPotentialUpgrade = 0]);
}

class LanguageLearnerUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "languageLearnerUpgrade";

  int languageMaxPotentialUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    languageMaxPotentialUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) => loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = LanguageLearnerUpgradeStatDynMapper.fromMap(staticData);
    languageMaxPotentialUpgrade = stat.languageMaxPotentialUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => LanguageLearnerUpgradeStatDyn(languageMaxPotentialUpgrade).toMap();
}
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/UpgradableInt.dart';
import 'package:flexbackend/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'LanguageLearner.mapper.dart';

@MappableClass()
class LanguageLearnerDynamic with LanguageLearnerDynamicMappable {
  int languageMaxPotential;
  List<AssetLink> languagesLearned;
  LanguageLearnerDynamic(this.languageMaxPotential, this.languagesLearned);
}

class LanguageLearnerComponent extends EyuunComponent<int> {
  static const String propertyName = "languageLearner";

  late UpgradableInt languageMaxPotential;
  late List<AssetLink> languagesLearned;

  bool canLearnNew() => languagesLearned.length < languageMaxPotential.current;
  int languagesLearnedCount() => languagesLearned.length;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = LanguageLearnerDynamicMapper.fromMap(dynamicData);
    languageMaxPotential = dyn.languageMaxPotential.upgradable;
    languagesLearned = dyn.languagesLearned;
  }

  @override
  Map<String, dynamic> saveDynamicData() => LanguageLearnerDynamic(languageMaxPotential.base, languagesLearned).toMap();

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // nothing to load here.
  }

  @override
  void reset() {
    languagesLearned = [];
    languageMaxPotential = 0.upgradable;
  }

}
import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'LanguageLearner.mapper.dart';

@MappableClass()
class LanguageLearnerDynamic with LanguageLearnerDynamicMappable {
  int languageMaxPotential;
  int languagesThroughProjects;
  List<AssetLink> languagesLearned;
  LanguageLearnerDynamic({
    this.languageMaxPotential = 0,
    List<AssetLink>? languagesLearned,
    this.languagesThroughProjects = 0,
  }) : languagesLearned = languagesLearned ?? [];
}

class LanguageLearnerComponent extends EyuunComponent<int> {
  static const String propertyName = "languageLearner";

  /// The language potential of the character
  late UpgradableInt languageMaxPotential;

  late int languagesThroughProjects;

  /// The list of languages learned.
  late List<AssetLink> languagesLearned;

  /// Returns whether a character can learn a new language
  bool canLearnNew() =>
      languagesLearned.length - languagesThroughProjects <
      languageMaxPotential.current;

  /// Returns the amount of languages already learned.
  int totalLanguagesCount() => languagesLearned.length;

  int getUsedPotential() => languagesLearned.length - languagesThroughProjects;

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
    languagesThroughProjects = dyn.languagesThroughProjects;
  }

  @override
  Map<String, dynamic> saveDynamicData() => LanguageLearnerDynamic(
    languageMaxPotential: languageMaxPotential.base,
    languagesLearned: languagesLearned,
  ).toMap();

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // nothing to load here.
  }

  @override
  void reset() {
    languagesLearned = [];
    languageMaxPotential = 0.upgradable;
    languagesThroughProjects = 0;
  }
}

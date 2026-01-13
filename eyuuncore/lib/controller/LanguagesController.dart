import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/registerServices.dart';

class LanguagesController {
  final LanguageLearnerComponent targetLearner;

  LanguagesController(this.targetLearner) {
    learnableLanguages = _evaluateLearnableLanguages();
  }

  List<Entity> learnableLanguages = [];

  List<Entity> _evaluateLearnableLanguages() {
    return locator<CharacterTablesFeatureComponent>()
        .languages
        .where((e) =>
            !targetLearner.languagesLearned.any((x) => x.id == e.getTypeId()))
        .toList();
  }

  bool canLearnNew() => targetLearner.canLearnNew();

  bool canLearn(Entity language) {
    return targetLearner.canLearnNew()
        // and language isn't already learned.
        &&
        !targetLearner.languagesLearned
            .any((e) => e.id == language.getTypeId());
  }

  void learnLanguage(Entity language, {bool throughProject = false}) {
    targetLearner.languagesLearned.add(AssetLink(language.getTypeId()));
    if (throughProject) {
      targetLearner.languagesThroughProjects += 1;
    }
    learnableLanguages = _evaluateLearnableLanguages();
  }

  int getRemainingPotential() =>
      targetLearner.languageMaxPotential.current -
      targetLearner.getUsedPotential();
}

import 'package:EyuunApp/components/LanguageLearner.dart';
import 'package:EyuunApp/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

import '../components/AssetBundle.dart';
import '../core/assetLink.dart';
import '../core/registerServices.dart';
import '../core/services/assetloader.dart';

class LanguagesController {
  final LanguageLearnerComponent targetLearner;

  final List<Entity> allLanguages = locator<AssetLoader>()
      .getStatic("all_languages_pool")
      ?.get<AssetBundleComponent>()
      ?.assets
      .getAssets() ??
      [];

  LanguagesController(this.targetLearner) {
    learnableLanguages = _evaluateLearnableLanguages();
  }

  List<Entity> learnableLanguages = [];

  List<Entity> _evaluateLearnableLanguages() {
    return allLanguages.where((e) => !targetLearner.languagesLearned.any((x) => x.id == e.getTypeId())).toList();
  }

  bool canLearnNew() => targetLearner.canLearnNew();

  bool canLearn(Entity language) {
    return
      targetLearner.canLearnNew()
      // and language isn't already learned.
      && !targetLearner.languagesLearned.any((e) => e.id == language.getTypeId());
  }

  void learnLanguage(Entity language, {bool throughProject = false}) {
    targetLearner.languagesLearned.add(AssetLink(language.getTypeId()));
    if(throughProject){
      targetLearner.languagesThroughProjects += 1;
    }
    learnableLanguages = _evaluateLearnableLanguages();
  }

  int getRemainingPotential() => targetLearner.languageMaxPotential.current - targetLearner.getUsedPotential();
}
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/popup/PickActionPopup.dart';

class DecideActionCategoryPopup extends StatelessWidget {
  const DecideActionCategoryPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: ArtDecoBoxDecoration(
            cornerBuilder: (p) => DoubleLineCornerPainter(p),
            verticalLineBuilder: (p) => DoubleLinePainter(p),
            horizontalLineBuilder: (p) => DoubleLinePainter(p),
            paint: Brushes.goldSparkling()..strokeWidth = 1.5,
            cornerSize: 12),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EyuunWidgets.spacerVertical(),
                  Center(
                      child: Text(
                    locator<TextService>().getText('uitext_pickselectlist'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  EyuunWidgets.spacerVertical(),
                  Divider(),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.floatingActionButton(
                      height: 60,
                      text:
                          locator<TextService>().getText('uitext_picknewtrick'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        PopupUtil.largePopup(
                            context,
                            PickActionPopup(
                                onPicked: (trick) {
                                  var skillLearner = locator<CharacterService>().character.get<SkillLearnerComponent>();
                                  if(skillLearner == null){
                                    return;
                                  }
                                  var controller = SkillLearnerController(skillLearner: skillLearner);
                                  controller.pickTrick(trick);
                                },
                                actions:
                                    locator<CharacterTablesFeatureComponent>()
                                        .tricks,
                                headerKey: 'uitext_picknewtrick'),
                            header: locator<TextService>()
                                .getText('uitext_picknewtrick'),
                            background:
                                AssetImage('data/base/ui/bg/background.jpg'));
                      }),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.floatingActionButton(
                      height: 60,
                      text:
                          locator<TextService>().getText('uitext_picknewspell'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        PopupUtil.largePopup(
                            context,
                            PickActionPopup(
                                actions:
                                    locator<CharacterTablesFeatureComponent>()
                                        .spells,
                                headerKey: 'uitext_picknewspell'),
                            header: locator<TextService>()
                                .getText('uitext_picknewspell'),
                            background:
                                AssetImage('data/base/ui/bg/background.jpg'));
                      })
                ])));
  }
}

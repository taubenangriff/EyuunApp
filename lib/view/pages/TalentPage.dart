import 'package:eyuunapp/view/widgets/cards/TalentsWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Talent.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:flutter/material.dart';

import '../widgets/eyuun/EyuunWidgets.dart';

class TalentPage extends StatefulWidget {
  final double desiredSize;
  final SkillLearnerController? controller;

  const TalentPage({super.key, this.desiredSize = 1100, this.controller});

  @override
  State<TalentPage> createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  late var skillLearner =
      locator<CharacterService>().character.get<SkillLearnerComponent>();

  late var controller =
      widget.controller ?? SkillLearnerController(skillLearner: skillLearner!);
  late var textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.desiredSize),
                child: Column(children: [
                  EyuunWidgets.eyuunBox(
                      child: Column(
                        children: [
                          Text(
                            textService.getText('uitext_basictalents'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          EyuunWidgets.spacerVertical(),
                          Text(textService.getText('uitext_basictalents_sub'),
                              textAlign: TextAlign.center),
                          EyuunWidgets.spacerVertical(),
                          if (skillLearner != null)
                            TalentsWidget(
                              onTalentChanged: () {
                                setState(() {});
                              },
                              skillLearnerController: controller,
                              filter: const [TalentGroup.Basic],
                            )
                        ],
                      ),
                      theme: theme),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.eyuunBox(
                      child: Column(
                        children: [
                          Text(
                            textService.getText('uitext_advancedtalents'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          EyuunWidgets.spacerVertical(),
                          Text(
                              textService.getText('uitext_advancedtalents_sub'),
                              textAlign: TextAlign.center),
                          EyuunWidgets.spacerVertical(),
                          if (skillLearner != null)
                            TalentsWidget(
                              onTalentChanged: () {
                                setState(() {});
                              },
                              skillLearnerController: controller,
                              filter: const [TalentGroup.Advanced],
                            )
                        ],
                      ),
                      theme: theme),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.eyuunBox(
                      child: Column(
                        children: [
                          Text(
                            textService.getText('uitext_spellschools'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          EyuunWidgets.spacerVertical(),
                          Text(textService.getText('uitext_spellschools_sub'),
                              textAlign: TextAlign.center),
                          EyuunWidgets.spacerVertical(),
                          if (skillLearner != null)
                            TalentsWidget(
                              onTalentChanged: () {
                                setState(() {});
                              },
                              skillLearnerController: controller,
                              filter: const [TalentGroup.Spellschool],
                            ),
                          EyuunWidgets.spacerVertical(),
                          Text(
                            textService
                                .getText('uitext_spellschools_thresholds'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      theme: theme),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.eyuunBox(
                      child: Column(
                        children: [
                          Text(
                            textService.getText('uitext_fightingstyles'),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          EyuunWidgets.spacerVertical(),
                          Text(textService.getText('uitext_fightingstyles_sub'),
                              textAlign: TextAlign.center),
                          EyuunWidgets.spacerVertical(),
                          if (skillLearner != null)
                            TalentsWidget(
                              onTalentChanged: () {
                                setState(() {});
                              },
                              skillLearnerController: controller,
                              filter: const [TalentGroup.FightingStyle],
                            )
                        ],
                      ),
                      theme: theme),
                ]))),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Text(
          'Skillpoints: ${skillLearner?.getSpentSkillpoints()}/${skillLearner?.skillpoints.current}',
          style: theme.textTheme.headlineMedium),
    );
  }
}

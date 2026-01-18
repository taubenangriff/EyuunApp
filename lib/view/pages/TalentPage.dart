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

  const TalentPage({super.key, this.desiredSize = 1100});

  @override
  State<TalentPage> createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  late var skillLearner =
      locator<CharacterService>().character.get<SkillLearnerComponent>();

  late var controller = SkillLearnerController(skillLearner: skillLearner!);

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
                            const Text(
                              'Basic',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            EyuunWidgets.spacerVertical(),
                            if (skillLearner != null)
                              TalentsWidget(
                                onTalentChanged: () {
                                  setState(() { });
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
                            const Text(
                              'Advanced',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            EyuunWidgets.spacerVertical(),
                            if (skillLearner != null)
                              TalentsWidget(
                                onTalentChanged: () {
                                  setState(() { });
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
                            const Text(
                              'Spellschools',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            EyuunWidgets.spacerVertical(),
                            if (skillLearner != null)
                              TalentsWidget(
                                onTalentChanged: () {
                                  setState(() { });
                                },
                                skillLearnerController: controller,
                                filter: const [TalentGroup.Spellschool],
                              )
                          ],
                        ),
                        theme: theme),
                    EyuunWidgets.spacerVertical(),
                    EyuunWidgets.eyuunBox(
                        child: Column(
                          children: [
                            const Text(
                              'Fighting Styles:',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            EyuunWidgets.spacerVertical(),
                            if (skillLearner != null)
                              TalentsWidget(
                                onTalentChanged: () {
                                  setState(() { });
                                },
                                skillLearnerController: controller,
                                filter: const [TalentGroup.FightingStyle],
                              )
                          ],
                        ),
                        theme: theme),
                  ]))),
        )));
  }
}

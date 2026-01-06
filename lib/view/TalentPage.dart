import 'package:EyuunApp/view/widgets/cards/TalentsWidget.dart';
import 'package:EyuunApp/view/widgets/eyuun/Brushes.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Talent.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:EyuunApp/view/widgets/DiceIcon.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:flutter/material.dart';

class TalentPage extends StatefulWidget {
  final double desiredSize;

  const TalentPage({super.key, this.desiredSize = 1100});

  @override
  State<TalentPage> createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  late var talents = locator<CharacterService>()
          .character
          .get<SkillLearnerComponent>()
          ?.skills ??
      [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.desiredSize),
              child: Column(children: [
                DecoratedBox(
                    decoration: EyuunDecoration(
                        paint: Brushes.goldSparkling(), cornerSize: 20,
                        background: theme.canvasColor.withAlpha(120)),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Basic',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            TalentsWidget(
                              talents: talents,
                              filter: const [TalentGroup.Basic],
                            )
                          ],
                        ))),
                SizedBox(height: 16),
                DecoratedBox(
                    decoration: EyuunDecoration(
                        paint: Brushes.goldSparkling(), cornerSize: 20,
                        background: theme.canvasColor.withAlpha(120)),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Advanced',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            TalentsWidget(
                              talents: talents,
                              filter: const [TalentGroup.Advanced],
                            )
                          ],
                        ))),
                SizedBox(height: 16),
                DecoratedBox(
                    decoration: EyuunDecoration(
                        paint: Brushes.goldSparkling(), cornerSize: 20,
                        background: theme.canvasColor.withAlpha(120)),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Spellschools',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            TalentsWidget(
                              talents: talents,
                              filter: const [TalentGroup.Spellschool],
                            )
                          ],
                        ))),
                SizedBox(height: 16),
                DecoratedBox(
                    decoration: EyuunDecoration(
                        paint: Brushes.goldSparkling(), cornerSize: 20,
                        background: theme.canvasColor.withAlpha(120)),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Fighting Styles:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            TalentsWidget(
                              talents: talents,
                              filter: const [TalentGroup.FightingStyle],
                            )
                          ],
                        ))),
              ]))),
    )));
  }
}

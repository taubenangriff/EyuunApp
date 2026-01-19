import 'package:eyuunapp/view/popup/DecideActionCategoryPopup.dart';
import 'package:eyuunapp/view/widgets/PickActionWidget.dart';
import 'package:eyuunapp/view/widgets/cards/ActionsWidget.dart';
import 'package:eyuunapp/view/widgets/cards/TalentsWidget.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuunapp/view/popup/ChangeHealthPopup.dart';
import 'package:eyuunapp/view/popup/ChangeValuePopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/cards/CombatStatsRow.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/controller/HealthController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../controller/ChangeValueController.dart';
import '../popup/PickActionPopup.dart';
import '../widgets/eyuun/EyuunWidgets.dart';

class CombatPage extends StatefulWidget {
  const CombatPage({super.key});

  @override
  State<CombatPage> createState() => _CombatPageState();
}

class _CombatPageState extends State<CombatPage> {
  @override
  Widget build(BuildContext context) {
    var character = locator<CharacterService>().character;
    var health = character.get<HealthComponent>()!;
    var flux = character.get<FluxComponent>()!;

    var combat = character.get<CombatComponent>();

    final fluxController = ChangeValueController(flux.fluxSpent,
        maxLimit: flux.fluxCapacity.current,
        minLimit: 0,
        onValUpdated: (val) => flux.fluxSpent = val);

    late double desiredSize = 1100;

    var skillLearner =
        locator<CharacterService>().character.get<SkillLearnerComponent>();

    late var talents = skillLearner?.skills ?? [];

    var actionUser = character.get<ActionUserComponent>();
    var attributes = character.get<AttributesComponent>();

    final theme = Theme.of(context);

    var healthProgress = health.hitpoints / health.maxHitpoints.current;
    var fluxProgress = flux.fluxSpent / flux.fluxMaximum.current;
    int healthSegments = (health.maxHitpoints.current / 10 + 1).floor();
    int fluxSegments = (flux.fluxMaximum.current / 10 + 1).floor();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Column(children: [
                  if (combat != null)
                    EyuunWidgets.informationBox(
                        child: EyuunWidgets.eyuunBox(
                            child: CombatStatsRow(
                                combat: combat, skillLearner: skillLearner!),
                            theme: theme),
                        link: 'https://eyuun.de/kaempfe'),
                  EyuunWidgets.spacerVertical(),
                  if (actionUser != null &&
                      attributes != null &&
                      skillLearner != null)
                    EyuunWidgets.eyuunBox(
                        child: ActionsWidget(
                            actionUser: actionUser,
                            attributes: attributes,
                            skillLearner: skillLearner),
                        theme: theme)
                ])),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EyuunWidgets.circularProgressButton(
            onPressed: () {
              final healthController = HealthController();
              healthController.setDamageTarget(character);

              PopupUtil.popup(
                  context,
                  ChangeHealthPopup(healthController, onAccept: () {
                    setState(() {});
                  }),
                  maximumSize: Size(350, 800));
            },
            segments: healthSegments,
            progressColor: Colors.green.shade600,
            progress: healthProgress,
            text:
                "${health.temporaryHitpoints > 0 ? "${health.hitpoints}+${health.temporaryHitpoints}" : "${health.hitpoints}"} / ${health.maxHitpoints.current}",
            tooltip: 'Health',
            icon: Icons.heart_broken,
          ),
          EyuunWidgets.spacerHorizontal(),
          EyuunWidgets.circularProgressButton(
            onPressed: () {
              PopupUtil.popup(
                  context,
                  ChangeValuePopup(fluxController, valueChanged: (change) {
                    setState(() {
                      fluxController.change(change);
                    });
                  }));
            },
            segments: fluxSegments,
            progressColor: Colors.blue.shade700,
            progress: fluxProgress,
            text:
                '${flux.fluxSpent}/${flux.fluxCapacity.current} (${flux.fluxMaximum.current})',
            tooltip: 'flux',
            icon: Icons.water,
          ),
          EyuunWidgets.spacerHorizontal(),
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              PopupUtil.popup(
                  context,
                  const DecideActionCategoryPopup());
            },
            text:
            'Add',
            tooltip: 'Add trick or Spell',
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

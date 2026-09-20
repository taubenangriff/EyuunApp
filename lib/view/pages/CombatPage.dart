import 'dart:math';

import 'package:eyuunapp/view/popup/ChangeFluxPopup.dart';
import 'package:eyuunapp/view/popup/ChangeHealthPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/PickActionWidget.dart';
import 'package:eyuunapp/view/widgets/cards/ActionsWidget.dart';
import 'package:eyuunapp/view/widgets/cards/CombatStatsRow.dart';
import 'package:eyuunapp/view/widgets/cards/DyingWidget.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/controller/DyingStateController.dart';
import 'package:eyuuncore/controller/HealthController.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:oxygen/oxygen.dart';

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
    final fluxCapacityController = ChangeValueController(
      flux.fluxCapacity.current,
      maxLimit: flux.fluxMaximum.current,
      minLimit: 0,
      onValUpdated: (val) =>
          flux.fluxCapacity.base = val - flux.fluxCapacity.upgrade,
    );

    late double desiredSize = 1100;

    var skillLearner =
        locator<CharacterService>().character.get<SkillLearnerComponent>();

    late var talents = skillLearner?.skills ?? [];

    var actionUser = character.get<ActionUserComponent>();
    var attributes = character.get<AttributesComponent>();

    final theme = Theme.of(context);

    var healthProgress = health.hitpoints / health.maxHitpoints.current;
    var fluxProgress = flux.fluxSpent / flux.fluxMaximum.current;
    int healthSegments =
        max((((health.maxHitpoints.current / 40)).round() * 4), 4);
    int fluxSegments = max((((flux.fluxMaximum.current / 40)).round() * 4), 4);

    var isDying = health.isInDyingState();
    var dyingStateController = DyingStateController(character);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Column(children: [
                  if (combat != null)
                    EyuunWidgets.informationBox(
                        child: EyuunWidgets.cardBox(
                            child: CombatStatsRow(
                                combat: combat, skillLearner: skillLearner!),
                            theme: theme),
                        link: 'https://eyuun.de/kaempfe'),
                  EyuunWidgets.spacerWidget(),
                  if (isDying) ...{
                    EyuunWidgets.informationBox(
                        child: EyuunWidgets.cardBox(
                            child:
                                DyingWidget(controller: dyingStateController),
                            theme: theme),
                        link:
                            'https://eyuun.de/charaktere-level#temporaere-leben-rasten--sterben'),
                    EyuunWidgets.spacerWidget(),
                  },
                  if (actionUser != null &&
                      attributes != null &&
                      skillLearner != null)
                    EyuunWidgets.cardBox(
                        child: ActionsWidget(
                            actionUser: actionUser,
                            attributes: attributes,
                            skillLearner: skillLearner),
                        theme: theme),
                  SizedBox(height: 200)
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
                  header:
                      locator<TextService>().getText('uitext_change_health'),
                  maximumSize: Size(350, 800));
            },
            segments: healthSegments,
            progressColor: isDying ? Colors.red : Colors.green.shade600,
            progress: isDying ? 1 : healthProgress,
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
                  ChangeFluxPopup(fluxController, fluxCapacityController,
                      onAccept: () {
                    setState(() {});
                  }),
                  header: locator<TextService>().getText('uitext_change_flux'),
                  maximumSize: const Size(600, 600));
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
              if (skillLearner == null) {
                return;
              }
              final skillLearnerController =
                  SkillLearnerController(skillLearner: skillLearner);

              PopupUtil.largePopup(
                context,
                PickActionWidget(
                  tricksBuilder: skillLearnerController.getAvailableTricks,
                  spellsBuilder: skillLearnerController.getAvailableSpells,
                  onTrickPicked: (entity) => _pickAction(
                    skillLearner,
                    entity,
                    isTrick: true,
                  ),
                  onSpellPicked: (entity) => _pickAction(
                    skillLearner,
                    entity,
                    isTrick: false,
                  ),
                ),
                header: '!Pick',
                background: const AssetImage('data/base/ui/bg/background.jpg'),
              );
            },
            text: 'Add',
            tooltip: 'Add trick or Spell',
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  void _pickAction(
    SkillLearnerComponent skillLearner,
    Entity entity, {
    required bool isTrick,
  }) {
    final skillLearnerController =
        SkillLearnerController(skillLearner: skillLearner);

    setState(() {
      if (isTrick) {
        skillLearnerController.pickTrick(entity);
      } else {
        skillLearnerController.pickSpell(entity);
      }
      locator<WorldManager>().execute();
    });
    Navigator.of(context).pop();
  }
}

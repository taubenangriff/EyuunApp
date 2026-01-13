import 'package:EyuunApp/view/widgets/cards/ActionsWidget.dart';
import 'package:EyuunApp/view/widgets/cards/TalentsWidget.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:EyuunApp/view/popup/ChangeHealthPopup.dart';
import 'package:EyuunApp/view/popup/ChangeValuePopup.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:EyuunApp/view/widgets/Cards/CombatStatsRow.dart';
import 'package:EyuunApp/view/widgets/eyuun/Brushes.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/controller/HealthController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'controller/ChangeValueController.dart';

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

    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Column(children: [
                  if (combat != null)
                    Stack(
                      children: [
                        DecoratedBox(
                          decoration: EyuunDecoration(
                              cornerSize: 20,
                              paint: Brushes
                                  .goldSparkling()), // intentionally empty
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CombatStatsRow(
                                  combat: combat, skillLearner: skillLearner!)),
                        ),
                        // The info button in the top right corner
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: 'More info on Combat',
                            onPressed: () async {
                              const url = 'https://eyuun.de/kaempfe';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  if(actionUser != null && attributes != null && skillLearner != null)
                    DecoratedBox(
                        decoration: EyuunDecoration(
                            paint: Brushes.goldSparkling(), cornerSize: 20),
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Text(
                                  'Actions',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16),
                                ActionsWidget(actionUser: actionUser, attributes: attributes, skillLearner: skillLearner)
                              ],
                            ))),
                ])),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLargeFab(
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
            text:
                "${health.temporaryHitpoints > 0 ? "${health.hitpoints}+${health.temporaryHitpoints}" : "${health.hitpoints}"} / ${health.maxHitpoints.current}",
            tooltip: 'Health',
            icon: Icons.heart_broken,
          ),
          const SizedBox(width: 16),
          _buildLargeFab(
            onPressed: () {
              PopupUtil.popup(
                  context,
                  ChangeValuePopup(fluxController, valueChanged: (change) {
                    setState(() {
                      fluxController.change(change);
                    });
                  }));
            },
            text:
                '${flux.fluxSpent}/${flux.fluxCapacity.current} (${flux.fluxMaximum.current})',
            tooltip: 'flux',
            icon: Icons.water,
          ),
        ],
      ),
    );
  }

  Widget _buildLargeFab(
      {required IconData icon,
      required VoidCallback onPressed,
      required String text,
      String tooltip = ""}) {
    var color = Color(0xccfdcc3a);
    return SizedBox(
        width: 130,
        height: 90,
        child: DecoratedBox(
            decoration:
                EyuunDecoration(cornerSize: 12, paint: Brushes.goldSparkling()),
            position: DecorationPosition.foreground,
            child: FloatingActionButton(
                heroTag: text,
                tooltip: tooltip,
                onPressed: onPressed,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 36, color: color),
                      Text(text, style: TextStyle(color: color))
                    ]))));
  }
}

import 'dart:math';

import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/ChangeHealthPopup.dart';
import 'package:eyuunapp/view/popup/ChangeValuePopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/cards/AttributesWidget.dart';
import 'package:eyuunapp/view/widgets/cards/CharacterInfoWidget.dart';
import 'package:eyuunapp/view/widgets/cards/LanguagesWidget.dart';
import 'package:eyuunapp/view/widgets/cards/PathsWidget.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/controller/HealthController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/popup/PauseRestPopup.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 1100;

    var character = locator<CharacterService>().character;
    var health = character.get<HealthComponent>()!;
    var flux = character.get<FluxComponent>()!;
    var languageLearner = character.get<LanguageLearnerComponent>();

    final fluxController = ChangeValueController(flux.fluxSpent,
        maxLimit: flux.fluxCapacity.current,
        minLimit: 0,
        onValUpdated: (val) => flux.fluxSpent = val);

    final ImageProvider placeholderImage = const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3');

    var healthProgress = health.hitpoints / health.maxHitpoints.current;
    var fluxProgress = flux.fluxSpent / flux.fluxMaximum.current;
    int healthSegments = max((((health.maxHitpoints.current / 40)).round() * 4), 4);
    int fluxSegments = max((((flux.fluxMaximum.current / 40)).round() * 4), 4);

    var isDying = health.isInDyingState();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Column(
                  children: [
                    EyuunWidgets.informationBox(
                        child: EyuunWidgets.cardBox(
                            child: CharacterInfoWidget(
                              profileImage: placeholderImage,
                              name: "Glup Shitto",
                              character: character,
                            ),
                            theme: theme),
                        link:
                            'https://eyuun.de/charaktererstellung#vergangenheit'),
                    EyuunWidgets.spacerWidget(),
                    EyuunWidgets.informationBox(
                        child: EyuunWidgets.cardBox(
                            child: AttributesWidget(), theme: theme),
                        link:
                            'https://eyuun.de/proben-projekte#eigenschaftenwuerfe--proben'),
                    EyuunWidgets.spacerWidget(),
                    EyuunWidgets.informationBox(
                        child: EyuunWidgets.cardBox(
                            child: PathsWidget(), theme: theme),
                        link: 'https://eyuun.de/charaktere-level#pfade'),
                    if (languageLearner != null)
                      EyuunWidgets.spacerWidget(),
                    if (languageLearner != null)
                      EyuunWidgets.informationBox(
                          child: EyuunWidgets.cardBox(
                              child: LanguageGrid(learner: languageLearner),
                              theme: theme),
                          link: 'https://eyuun.de/charaktere-level#sprachen'),
                    SizedBox(height: 200)
                  ],
                ))),
      ),
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
            progressColor: isDying ? Colors.red : Colors.green.shade600,
            progress: isDying ? 1 : healthProgress,
            text:
                "${health.temporaryHitpoints > 0 ? "${health.hitpoints}+${health.temporaryHitpoints}" : "${health.hitpoints}"} / ${health.maxHitpoints.current}",
            tooltip: 'Health',
            icon: Icons.heart_broken,
          ),
          const SizedBox(width: 16),
          EyuunWidgets.circularProgressButton(
            onPressed: () {
              locator<WorldManager>().world.execute(1);
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
          const SizedBox(width: 16),
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              PopupUtil.popup(context, PauseRestPopup(),
                  maximumSize: const Size(700, 470));
            },
            text: 'Rest',
            tooltip: 'Conduct a rest',
            icon: Icons.bed_outlined,
          ),
        ],
      ),
    );
  }
}

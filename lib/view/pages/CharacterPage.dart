import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/controller/HealthController.dart';
import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/ChangeHealthPopup.dart';
import 'package:eyuunapp/view/popup/ChangeValuePopup.dart';
import 'package:eyuunapp/view/widgets/Cards/AttributesWidget.dart';
import 'package:eyuunapp/view/widgets/Cards/CharacterInfoWidget.dart';
import 'package:eyuunapp/view/widgets/Cards/PathsWidget.dart';
import 'package:eyuunapp/view/widgets/cards/LanguagesWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:flutter/material.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../popup/PauseRestPopup.dart';
import '../widgets/eyuun/EyuunWidgets.dart';

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

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Column(
                  children: [
                    Stack(children: [
                      DecoratedBox(
                        decoration: EyuunDecoration(
                            cornerSize: 20, paint: Brushes.goldSparkling(),
                            background: theme.canvasColor.withAlpha(120)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CharacterInfoWidget(
                            profileImage: placeholderImage,
                            name: "Glup Shitto",
                            character: character,
                          ),
                        ),
                      ),
                      // The info button in the top right corner
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          icon: const Icon(Icons.info_outline),
                          tooltip: 'More info on Character Background',
                          onPressed: () async {
                            const url =
                                'https://eyuun.de/charaktererstellung#vergangenheit';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 16),
                    Stack(
                      children: [
                        // The decorated box with your content
                        DecoratedBox(
                          decoration: EyuunDecoration(
                              cornerSize: 20,
                              paint: Brushes.goldSparkling(),
                              background: theme.canvasColor.withAlpha(120)),
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: AttributesWidget(),
                          ),
                        ),
                        // The info button in the top right corner
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: 'More info on Attributes',
                            onPressed: () async {
                              const url =
                                  'https://eyuun.de/proben-projekte#eigenschaftenwuerfe--proben';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Stack(
                      children: [
                        // The decorated box with your content
                        DecoratedBox(
                          decoration: EyuunDecoration(
                              cornerSize: 20, paint: Brushes.goldSparkling(),
                              background: theme.canvasColor.withAlpha(120)),
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: PathsWidget(),
                          ),
                        ),
                        // The info button in the top right corner
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: 'More info on Paths',
                            onPressed: () async {
                              const url =
                                  'https://eyuun.de/charaktere-level#pfade';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (languageLearner != null) SizedBox(height: 16),
                    if (languageLearner != null)
                      Stack(
                        children: [
                          // The decorated box with your content
                          DecoratedBox(
                            decoration: EyuunDecoration(
                                cornerSize: 20, paint: Brushes.goldSparkling()),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: LanguageGrid(learner: languageLearner),
                            ),
                          ),
                          // The info button in the top right corner
                          Positioned(
                            top: 12,
                            right: 12,
                            child: IconButton(
                              icon: const Icon(Icons.info_outline),
                              tooltip: 'More info on Languages',
                              onPressed: () async {
                                const url =
                                    'https://eyuun.de/charaktere-level#sprachen';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 200)
                  ],
                ))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EyuunWidgets.floatingActionButton(
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
          EyuunWidgets.floatingActionButton(
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
            text:
                '${flux.fluxSpent}/${flux.fluxCapacity.current} (${flux.fluxMaximum.current})',
            tooltip: 'flux',
            icon: Icons.water,
          ),
          const SizedBox(width: 16),
          EyuunWidgets.floatingActionButton(
            onPressed: () {
              PopupUtil.popup(
                  context, PauseRestPopup(), maximumSize: const Size(700,470));
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

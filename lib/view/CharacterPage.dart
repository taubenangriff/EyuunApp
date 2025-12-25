import 'dart:math';

import 'package:EyuunApp/components/Flux.dart';
import 'package:EyuunApp/components/health.dart';
import 'package:EyuunApp/view/controller/ChangeValueController.dart';
import 'package:EyuunApp/view/popup/ChangeValuePopup.dart';
import 'package:EyuunApp/view/widgets/CharacterInfoWidget.dart';
import 'package:EyuunApp/view/widgets/PathsWidget.dart';
import 'package:EyuunApp/view/widgets/AttributesWidget.dart';
import 'package:flutter/material.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/registerServices.dart';
import '../core/services/CharacterService.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  var healthCurrent = 5;
  var healthMax = 50;

  var vitalityCurrent = 12;
  var vitalityMax = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 900;

    var character = locator<CharacterService>().character;
    var health = character.get<HealthComponent>()!;
    var flux = character.get<FluxComponent>()!;

    final healthController = ChangeValueController(health.hitpoints,
        maxLimit: health.maxHitpoints.current,
        minLimit: 0,
        onValUpdated: (val) => health.hitpoints = val);
    final vitalityController = ChangeValueController(vitalityCurrent,
        maxLimit: vitalityMax,
        minLimit: 0,
        onValUpdated: (val) => vitalityCurrent = val);
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
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.secondaryContainer,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CharacterInfoWidget(
                          profileImage: placeholderImage,
                          name: "Glup Shitto",
                          upbringing: "Trodatome",
                          level: 5,
                          ability: 3,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Stack(
                      children: [
                        // The decorated box with your content
                        DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: theme.colorScheme.secondaryContainer,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: AttributesWidget(),
                          ),
                        ),
                        // The info button in the top right corner
                        Positioned(
                          top: 4,
                          right: 4,
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
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: theme.colorScheme.secondaryContainer,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: PathsWidget(),
                          ),
                        ),
                        // The info button in the top right corner
                        Positioned(
                          top: 4,
                          right: 4,
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
                    SizedBox(height: 200)
                  ],
                ))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLargeFab(
            onPressed: () {
              PopupUtil.popup(
                context,
                ChangeValuePopup(healthController, valueChanged: (change) {
                  setState(() {
                    healthController.change(change);
                  });
                }),
              );
            },
            text: '${health.hitpoints}/${health.maxHitpoints.current}',
            tooltip: 'Health',
            icon: Icons.heart_broken,
          ),
          const SizedBox(width: 16),
          _buildLargeFab(
            onPressed: () {
              PopupUtil.popup(
                  context,
                  ChangeValuePopup(vitalityController, valueChanged: (change) {
                    setState(() {
                      vitalityController.change(change);
                    });
                  }));
            },
            text: '${vitalityCurrent}/${vitalityMax}',
            tooltip: 'vitality',
            icon: Icons.air,
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
            text: '${flux.fluxSpent}/${flux.fluxCapacity.current} (${flux.fluxMaximum.current})',
            tooltip: 'flow',
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
    return SizedBox(
        width: 120,
        height: 80,
        child: FloatingActionButton(
            heroTag: text,
            tooltip: tooltip,
            onPressed: onPressed,
            child: Row(
                mainAxisSize:
                    MainAxisSize.min, // 👈 prevents Row from stretching
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(icon, size: 36), Text(text)])));
  }
}

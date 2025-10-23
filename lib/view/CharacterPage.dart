import 'dart:math';

import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/widgets/CharacterInfoWidget.dart';
import 'package:flexbackend/view/widgets/PathsWidget.dart';
import 'package:flexbackend/view/widgets/BaseValues.dart';
import 'package:flutter/material.dart';
import 'package:flexbackend/view/popup/PopupUtil.dart';

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

  var flowCurrent = 120;
  var flowMax = 150;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 900;

    final healthController = ChangeValueController(healthCurrent,
        maxLimit: healthMax,
        minLimit: 0,
        onValUpdated: (val) => healthCurrent = val);
    final vitalityController = ChangeValueController(vitalityCurrent,
        maxLimit: vitalityMax,
        minLimit: 0,
        onValUpdated: (val) => vitalityCurrent = val);
    final flowController = ChangeValueController(flowCurrent,
        maxLimit: flowMax,
        minLimit: 0,
        onValUpdated: (val) => flowCurrent = val);

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
                              width: 1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CharacterInfoWidget(
                            profileImage: placeholderImage,
                            name: "Glup Shitto",
                            upbringing: "Trodatome",
                            level: 5,
                            ability: 3
                      ),
                    )),
                    SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.secondaryContainer,
                              width: 1),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: BaseStatsWidget(),
                      ),
                    ),
                    SizedBox(height: 16),
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
            text: '${healthCurrent}/${healthMax}',
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
                  ChangeValuePopup(flowController, valueChanged: (change) {
                    setState(() {
                      flowController.change(change);
                    });
                  }));
            },
            text: '${flowCurrent}/${flowMax}',
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

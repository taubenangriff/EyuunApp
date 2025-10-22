import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/widgets/PathsWidget.dart';
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

    final healthController = ChangeValueController(healthCurrent, maxLimit: healthMax, minLimit: 0);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
                color: theme.colorScheme.secondaryContainer, width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: PathsWidget(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLargeFab(
            onPressed: () {
              PopupUtil.popup(
                context,
                ChangeValuePopup(healthController, valueCallback: (val) {
                  setState(() {
                    healthController.change(val);
                    healthCurrent = healthController.value;
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
                  ChangeValuePopup(
                      ChangeValueController(vitalityCurrent,
                          maxLimit: vitalityMax, minLimit: 0),
                      valueCallback: (val) => vitalityCurrent = val));
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
                  ChangeValuePopup(
                      ChangeValueController(flowCurrent,
                          maxLimit: flowMax, minLimit: 0),
                      valueCallback: (val) => flowCurrent = val));
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

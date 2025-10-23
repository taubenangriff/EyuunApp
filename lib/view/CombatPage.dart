import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/popup/PopupUtil.dart';
import 'package:flutter/material.dart';

import 'controller/ChangeValueController.dart';

class CombatPage extends StatefulWidget {
  const CombatPage({super.key});

  @override
  State<CombatPage> createState() => _CombatPageState();
}

class _CombatPageState extends State<CombatPage> {

  @override
  Widget build(BuildContext context) {
    var healthCurrent = 5;
    var healthMax = 50;

    var vitalityCurrent = 12;
    var vitalityMax = 20;

    var flowCurrent = 120;
    var flowMax = 150;

    final healthController = ChangeValueController(healthCurrent,
        maxLimit: healthMax,
        minLimit: 0,
        onValUpdated: (val) => setState(() {
          healthCurrent = val;
        }));
    final vitalityController = ChangeValueController(vitalityCurrent,
        maxLimit: vitalityMax,
        minLimit: 0,
        onValUpdated: (val) => setState(() {
          vitalityCurrent = val;
        }));
    final flowController = ChangeValueController(flowCurrent,
        maxLimit: flowMax,
        minLimit: 0,
        onValUpdated: (val) => setState(() {
          flowCurrent = val;
        }));

    late double desiredSize = 900;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Text('Combat'))),
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
            text: '$flowCurrent/$flowMax',
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

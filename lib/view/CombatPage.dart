import 'package:EyuunApp/view/popup/ChangeHealthPopup.dart';
import 'package:EyuunApp/view/popup/ChangeValuePopup.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:flutter/material.dart';

import '../components/health.dart';
import '../controller/HealthController.dart';
import '../core/registerServices.dart';
import '../core/services/CharacterService.dart';
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

    var vitalityCurrent = 12;
    var vitalityMax = 20;

    var flowCurrent = 120;
    var flowMax = 150;

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

              final healthController = HealthController();
              healthController.setDamageTarget(character);

              PopupUtil.popup(
                  context,
                  ChangeHealthPopup(healthController, onAccept: () {
                    setState(() {});
                  }),
                  maximumSize: Size(300, 700));
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

import 'package:EyuunApp/view/popup/ChangeHealthPopup.dart';
import 'package:EyuunApp/view/popup/ChangeValuePopup.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:EyuunApp/view/widgets/eyuun/Brushes.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:flutter/material.dart';

import '../components/Flux.dart';
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

    var flux = character.get<FluxComponent>()!;

    var vitalityCurrent = 12;
    var vitalityMax = 20;

    final vitalityController = ChangeValueController(vitalityCurrent,
        maxLimit: vitalityMax,
        minLimit: 0,
        onValUpdated: (val) => setState(() {
          vitalityCurrent = val;
        }));
    final fluxController = ChangeValueController(flux.fluxSpent,
        maxLimit: flux.fluxCapacity.current,
        minLimit: 0,
        onValUpdated: (val) => flux.fluxSpent = val);

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
            text: "${health.shield > 0 ? "${health.hitpoints}+${health.shield}" : "${health.hitpoints}"} / ${health.maxHitpoints.current}",
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
            text: '${flux.fluxSpent}/${flux.fluxCapacity.current} (${flux.fluxMaximum.current})',
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
        child:
        DecoratedBox(
            decoration:
            EyuunDecoration(cornerSize: 12, paint: Brushes.goldSparkling()),
            position: DecorationPosition.foreground,
            child: FloatingActionButton(
                heroTag: text,
                tooltip: tooltip,
                backgroundColor: Color(0xee1e1f22),
                onPressed: onPressed,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(icon, size: 36, color: color), Text(text, style: TextStyle(color: color))]))));
  }
}

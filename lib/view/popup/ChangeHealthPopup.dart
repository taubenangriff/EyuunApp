import 'package:EyuunApp/components/DamageType.dart';
import 'package:EyuunApp/components/Icon.dart';
import 'package:EyuunApp/components/feature/CombatFeature.dart';
import 'package:EyuunApp/controller/HealthController.dart';
import 'package:EyuunApp/core/assetLink.dart';
import 'package:EyuunApp/core/components/EntityExtensions.dart';
import 'package:EyuunApp/view/controller/ChangeValueController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';
import '../widgets/ItemWheel.dart';

class ChangeHealthPopup extends StatefulWidget {
  const ChangeHealthPopup(this.healthController,
      {this.onAccept, this.horizontal = false, super.key});

  final HealthController healthController;
  final void Function()? onAccept;
  final bool horizontal;

  @override
  State<ChangeHealthPopup> createState() => _ChangeHealthPopupState();
}

class _ChangeHealthPopupState extends State<ChangeHealthPopup> {
  List<Entity> damageTypes =
      locator<CombatFeatureComponent>().damageTypes.getAssets();
  List<Entity> healTypes =
      locator<CombatFeatureComponent>().healTypes.getAssets();

  late int selectedDamageIndex = 0;
  late int selectedHealIndex = 0;

  late int hpChange = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Row(children: [
            SizedBox(
              height: 50,
              width: 100,
              child: Text('${widget.healthController.oldHitpoints}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30)),
            ),
            SizedBox(
                height: 200,
                width: 100,
                child: ItemWheel(
                    valueCallback: (i) => setState(() {
                          hpChange = i;
                          widget.healthController.setDamageType(hpChange > 0
                              ? healTypes[selectedHealIndex]
                              : damageTypes[selectedDamageIndex]);
                          widget.healthController.computeDamageSplit(hpChange);
                        }),
                    maxValue: widget.healthController.maxGainable(),
                    minValue: -widget.healthController.maxLosable(),
                    horizontal: widget.horizontal)),
            SizedBox(
              width: 100,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("armor blocks:", style: TextStyle(fontSize: 12)),
                  Text(
                      "${widget.healthController.absorbedByArmor}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: widget.healthController.armorUsedAgainstTarget() ? Colors.red : Colors.blueAccent)),
                  const Text("new shield:", style: TextStyle(fontSize: 12)),
                  Text("${widget.healthController.newShield}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30)),
                  const Text("new hitpoints:", style: TextStyle(fontSize: 12)),
                  Text("${widget.healthController.newHitpoints}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: widget.healthController.isLosingHealth() ? Colors.red : Colors.green)),
                ],
              ),
            )
          ]),
        ),
        Text(
          locator<TextService>().getText(
              widget.healthController.damageTypeEntity?.getTypeId() ?? ""),
          style: const TextStyle(fontSize: 24),
        ),
        Visibility(
            visible: hpChange < 0,
            maintainState: true,
            child: SizedBox(
                width: 200,
                height: 80,
                child: ItemWheel(
                    maxValue: damageTypes.length - 1,
                    valueIsIndex: true,
                    valueCallback: (index) {
                      setState(() {
                        selectedDamageIndex = index;
                        widget.healthController
                            .setDamageType(damageTypes[selectedDamageIndex]);
                        widget.healthController.computeDamageSplit(hpChange);
                      });
                    },
                    childWidget: (index) =>
                        damageTypes[index].has<IconComponent>()
                            ? Image(
                                height: 64,
                                width: 64,
                                image: AssetImage(damageTypes[index]
                                    .get<IconComponent>()!
                                    .iconFilepath))
                            : const Text("fuck"),
                    horizontal: true))),
        Visibility(
            maintainState: true,
            visible: hpChange >= 0,
            child: SizedBox(
                width: 200,
                height: 80,
                child: ItemWheel(
                    maxValue: healTypes.length - 1,
                    valueIsIndex: true,
                    valueCallback: (index) {
                      setState(() {
                        selectedHealIndex = index;
                        widget.healthController
                            .setDamageType(healTypes[selectedHealIndex]);
                        widget.healthController.computeDamageSplit(hpChange);
                      });
                    },
                    childWidget: (index) =>
                        damageTypes[index].has<IconComponent>()
                            ? Image(
                                image: AssetImage(healTypes[index]
                                    .get<IconComponent>()!
                                    .iconFilepath))
                            : const Text("fuck"),
                    horizontal: true))),
        if (locator<TextService>().hasFluff(
            widget.healthController.damageTypeEntity?.getTypeId() ?? ""))
          Text(
              locator<TextService>().getFluff(
                  widget.healthController.damageTypeEntity?.getTypeId() ?? ""),
              style: const TextStyle(fontSize: 12)),
        if (widget.healthController.damageTypeComponent.degradeArmor)
          Text(locator<TextService>().getText("uitext_degradeArmor")),
        if (widget.healthController.damageTypeComponent.useFreezingLogic)
          Text(locator<TextService>().getText("uitext_freezing_logic")),
        if (widget.healthController.damageTypeComponent.applyStatusEffect !=
            null)
          Text(locator<TextService>().getText("uitext_applyStatusEffect")),
        if (widget.healthController.damageTypeComponent
                    .applyStatusEffectOnHit !=
                null &&
            widget.healthController.hitpointChange != 0)
          Text(locator<TextService>().getText("uitext_applyStatusEffectOnHit")),
        if (widget.healthController.damageTypeComponent.pushback > 0)
          Text(locator<TextService>().getText("uitext_pushback")),
        SizedBox(
            width: 128,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: FloatingActionButton(
                    onPressed: () {
                      widget.healthController.apply();
                      Navigator.of(context).pop();
                      setState(() {
                        widget.onAccept?.call();
                      });
                    },
                    child: Text('Apply'))))
      ],
    );
  }
}

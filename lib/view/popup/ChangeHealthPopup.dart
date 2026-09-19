import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/components/Icon.dart';
import 'package:eyuuncore/components/feature/CombatFeature.dart';
import 'package:eyuuncore/controller/HealthController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/ItemWheel.dart';

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
  List<Entity> damageTypes = locator<CombatFeatureComponent>().damageTypes;
  List<Entity> healTypes = locator<CombatFeatureComponent>().healTypes;

  final resistances = [0, 0.5, 1, 1.5];

  late List<int> selectedDamageIndexes = [
    locator<CombatFeatureComponent>().damageTypesDefaultIndex
  ];
  late int selectedHealIndex = 0;
  int? selectedResistanceIndex;

  late int hpChange = 0;

  void _computeDamage() {
    if (hpChange >= 0) {
      widget.healthController.setDamageType(healTypes[selectedHealIndex]);
    } else {
      widget.healthController
          .setDamageType(damageTypes[selectedDamageIndexes.last]);
    }
    widget.healthController.computeDamageSplit(hpChange);
  }

  Widget _summaryColumn(String label, String value) {
    return SizedBox(
      width: 100,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22)),
        ],
      ),
    );
  }

  Widget _selectorRow({
    required String label,
    required Widget child,
    required VoidCallback? onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              SizedBox(width: 200, height: 80, child: child),
            ],
          ),
          IconButton(
            tooltip: 'Remove',
            onPressed: onRemove,
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _damageTypeWheel(int entryIndex) {
    return _selectorRow(
      label: locator<TextService>()
          .getText(damageTypes[selectedDamageIndexes[entryIndex]].getTypeId()),
      child: ItemWheel(
        key: ValueKey('damage-$entryIndex'),
        startValue: selectedDamageIndexes[entryIndex],
        maxValue: damageTypes.length - 1,
        valueIsIndex: true,
        customSize: 46,
        valueCallback: (index) {
          setState(() {
            selectedDamageIndexes[entryIndex] = index;
            _computeDamage();
          });
        },
        childWidget: (index) => damageTypes[index].has<IconComponent>()
            ? Image(
                height: 64,
                width: 64,
                image: AssetImage(
                    damageTypes[index].get<IconComponent>()!.iconFilepath))
            : const Icon(Icons.broken_image),
        horizontal: true,
      ),
      onRemove: selectedDamageIndexes.length > 1
          ? () => setState(() {
                selectedDamageIndexes.removeAt(entryIndex);
                _computeDamage();
              })
          : null,
    );
  }

  Widget _resistanceWheel() {
    return _selectorRow(
      label: locator<TextService>().getText("uitext_resistence"),
      child: ItemWheel(
        key: const ValueKey('resistance'),
        startValue: selectedResistanceIndex ?? 2,
        maxValue: resistances.length - 1,
        horizontal: true,
        valueIsIndex: true,
        valueCallback: (index) {
          setState(() {
            selectedResistanceIndex = index;
            widget.healthController
                .setProneFactor(resistances[index].toDouble());
            _computeDamage();
          });
        },
        childWidget: (index) =>
            Center(child: Text(resistances[index].toString())),
      ),
      onRemove: () => setState(() {
        selectedResistanceIndex = null;
        widget.healthController.setProneFactor(1);
        _computeDamage();
      }),
    );
  }

  Widget _information() {
    final information = <String>[];
    if (widget.healthController.absorbedByArmor != 0) {
      information
          .add('${widget.healthController.absorbedByArmor.abs()} from armor');
    }
    if (widget.healthController.tempHealthChange != 0) {
      information.add(
          '${widget.healthController.tempHealthChange.abs()} from temporary health');
    }
    if (widget.healthController.damageTypeComponent.applyStatusEffect != null) {
      information.add('+effect from status effect');
    }
    if (information.isEmpty) {
      information.add('No additional effects');
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: information
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(left: 24, top: 2),
                  child: Text('- $entry'),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              width: 400,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _summaryColumn('Current HP',
                        '${widget.healthController.oldHitpoints}+${widget.healthController.oldShield}'),
                    _summaryColumn('Armor Block',
                        '${widget.healthController.absorbedByArmor}'),
                    _summaryColumn('New Hitpoints',
                        '${widget.healthController.newHitpoints}+${widget.healthController.newShield}'),
                  ]),
            ),
            const SizedBox(height: 8),
            _information(),
            const SizedBox(height: 8),
            SizedBox(
              width: 260,
              height: 80,
              child: ItemWheel(
                valueCallback: (i) => setState(() {
                  hpChange = i;
                  _computeDamage();
                }),
                maxValue: widget.healthController.maxGainable(),
                minValue: -widget.healthController.maxLosable(),
                horizontal: true,
              ),
            ),
            if (hpChange >= 0)
              _selectorRow(
                label: 'Healing / temporary health',
                child: ItemWheel(
                  key: const ValueKey('healing'),
                  startValue: selectedHealIndex,
                  maxValue: healTypes.length - 1,
                  valueIsIndex: true,
                  customSize: 46,
                  valueCallback: (index) => setState(() {
                    selectedHealIndex = index;
                    _computeDamage();
                  }),
                  childWidget: (index) => healTypes[index].has<IconComponent>()
                      ? Image(
                          image: AssetImage(healTypes[index]
                              .get<IconComponent>()!
                              .iconFilepath))
                      : const Icon(Icons.favorite),
                  horizontal: true,
                ),
                onRemove: null,
              ),
            if (hpChange < 0)
              ...selectedDamageIndexes
                  .asMap()
                  .entries
                  .map((entry) => _damageTypeWheel(entry.key)),
            if (hpChange < 0 && selectedResistanceIndex != null)
              _resistanceWheel(),
            if (hpChange < 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'add-resistance',
                    mini: true,
                    tooltip: 'Add resistance',
                    onPressed: selectedResistanceIndex == null
                        ? () => setState(() => selectedResistanceIndex = 2)
                        : null,
                    child: const Icon(Icons.shield),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    heroTag: 'add-damage-type',
                    mini: true,
                    tooltip: 'Add damage type',
                    onPressed: () => setState(() => selectedDamageIndexes.add(
                        locator<CombatFeatureComponent>()
                            .damageTypesDefaultIndex)),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            EyuunWidgets.spacerVertical(),
            SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (locator<TextService>().hasFluff(widget
                              .healthController.damageTypeEntity
                              ?.getTypeId() ??
                          ""))
                        Text(
                            locator<TextService>().getFluff(widget
                                    .healthController.damageTypeEntity
                                    ?.getTypeId() ??
                                ""),
                            style: const TextStyle(fontSize: 12)),
                      if (widget
                          .healthController.damageTypeComponent.degradeArmor)
                        Text(locator<TextService>()
                            .getText("uitext_degradeArmor")),
                      if (widget.healthController.damageTypeComponent
                          .useFreezingLogic)
                        Text(locator<TextService>()
                            .getText("uitext_freezing_logic")),
                      if (widget.healthController.damageTypeComponent
                              .applyStatusEffect !=
                          null)
                        Text(locator<TextService>()
                            .getText("uitext_applyStatusEffect")),
                      if (widget.healthController.damageTypeComponent
                                  .applyStatusEffectOnHit !=
                              null &&
                          widget.healthController.hitpointChange != 0)
                        Text(locator<TextService>()
                            .getText("uitext_applyStatusEffectOnHit")),
                      if (widget.healthController.damageTypeComponent.pushback >
                          0)
                        Text(locator<TextService>().getText("uitext_pushback")),
                    ],
                  ),
                )),
            SizedBox(
                width: 178,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: ArtDecoBoxDecoration(
                            cornerBuilder: (p) => DoubleLineCornerPainter(p),
                            verticalLineBuilder: (p) => DoubleLinePainter(p),
                            horizontalLineBuilder: (p) => DoubleLinePainter(p),
                            paint: Brushes.goldSparkling()..strokeWidth = 1.5,
                            cornerSize: 12),
                        child: FloatingActionButton(
                            onPressed: () {
                              widget.healthController.apply();
                              Navigator.of(context).pop();
                              setState(() {
                                widget.onAccept?.call();
                              });
                            },
                            child: Text('Apply',
                                style: TextStyle(color: Color(0xccfdcc3a))))))),
            const SizedBox(height: 12)
          ],
        ));
  }
}

import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:eyuunapp/view/widgets/ActionDisplay.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ActionCard extends StatelessWidget {
  ActionCard(
      {super.key,
      required this.skillLearner,
      required this.attributes,
      required this.actionEntity,
      this.onTap,
      this.sourceEntity});

  final SkillLearnerComponent skillLearner;
  final AttributesComponent attributes;
  final Entity actionEntity;
  final Entity? sourceEntity;
  final VoidCallback? onTap;

  final TextService _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    var hasWeapon = actionEntity.has<WeaponComponent>();

    SkillcheckController skillcheckController =
        SkillcheckController(skillLearner);

    var theme = Theme.of(context);
    var actionComponent = actionEntity.get<ActionComponent>()!;

    return GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(builder: (context, constraints) {
          var enaughWidth = constraints.maxWidth > 240;

          return Card(
              borderOnForeground: true,
              elevation: 6,
              surfaceTintColor: theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: DecoratedBox(
                  decoration: ArtDecoBoxDecoration(
                      cornerBuilder: (p) => ThickThinThickCornerPainter(p),
                      verticalLineBuilder: (p) => ThickThinThickLinePainter(p),
                      horizontalLineBuilder: (p) =>
                          ThickThinThickLinePainter(p),
                      paint: Brushes.goldSparkling()..strokeWidth = 1.25,
                      cornerSize: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(fit: StackFit.passthrough, children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.pin_drop),
                      ),
                      if (actionComponent.fluxCost > 0) ...{
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.water, size: 24),
                              SizedBox(width: 6),
                              Text(
                                '${actionComponent.fluxCost}${(actionComponent.billingCycle != BillingCycle.Once) ? "/KR" : ""}',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      },
                      ActionDisplay(
                        showCost: false,
                          action: actionEntity,
                          source: sourceEntity,
                          textBehavior: TextBehavior.fade)
                    ]),
                  )));
        }));
  }
}

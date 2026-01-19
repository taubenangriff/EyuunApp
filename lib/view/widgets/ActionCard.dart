import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.pin_drop),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      _textService.getText(actionEntity
                          .get<ActionComponent>()!
                          .actionTime
                          .getTextKey()),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 44),
                      // 🏷 Title
                      Text(
                        _textService.getTextFromEntity(actionEntity) +
                            (sourceEntity != null
                                ? " (${_textService.getTextFromEntity(sourceEntity)})"
                                : ""),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // 📖 Description
                      Flexible(
                          child: Text(
                        _textService
                            .getActionDescriptionFromEntity(actionEntity),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                      )),

                      const SizedBox(height: 16),
                    ],
                  ),
                  // 🎲 Skill check widget
                  if (actionEntity.has<SkillcheckComponent>())
                    Positioned(
                        bottom: 4,
                        right: 0,
                        left: 0,
                        child: Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              SkillCheckWidget(
                                  skillcheck:
                                      actionEntity.get<SkillcheckComponent>()!,
                                  attributes: attributes,
                                  spacing: 8,
                                  showText: false,
                                  iconSize: enaughWidth ? 42 : 32),
                              Text(
                                  " + ${skillcheckController.getWeaponSkill(actionEntity)}",
                                  style: enaughWidth ? theme.textTheme.headlineMedium : theme.textTheme.bodyLarge)
                            ]))),
                ]),
              ));
        }));
  }
}

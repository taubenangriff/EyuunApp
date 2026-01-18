import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ActionCard extends StatelessWidget {
  ActionCard({
    super.key,
    required this.skillLearner,
    required this.attributes,
    required this.actionEntity,
    this.sourceEntity
  });

  final SkillLearnerComponent skillLearner;
  final AttributesComponent attributes;
  final Entity actionEntity;
  final Entity? sourceEntity;

  final TextService _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    var hasWeapon = actionEntity.has<WeaponComponent>();

    SkillcheckController skillcheckController =
    SkillcheckController(skillLearner);

    return GestureDetector(
        onTap: () {
          PopupUtil.popup(context, const Center(child: Text("Popup showing the action in full and a button to cast it.")), maximumSize: Size(600, 400));
        },
        child: Card(
            elevation: 4,
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
                    _textService.getText(
                        actionEntity.get<ActionComponent>()!.actionTime.getTextKey()),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 44),
                    // 🏷 Title
                    Text(
                      _textService.getTextFromEntity(actionEntity) + (sourceEntity != null ? " (${_textService.getTextFromEntity(sourceEntity)})" : ""),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // 📖 Description
                    Text(
                      _textService.getActionDescriptionFromEntity(actionEntity),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
                // 🎲 Skill check widget
                if (actionEntity.has<SkillcheckComponent>())
                  Positioned(
                      bottom: 4,
                      child: Center(
                          child: SkillCheckWidget(
                              skillcheck: actionEntity.get<SkillcheckComponent>()!,
                              attributes: attributes,
                              useWrap: false,
                              spacing: 0,
                              iconSize: 32))),
                if (hasWeapon)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Text(
                        "Skill: ${skillcheckController.getWeaponSkill(actionEntity)}"),
                  )
              ]),
            )));
  }
}
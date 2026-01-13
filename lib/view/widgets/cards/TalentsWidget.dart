import 'package:EyuunApp/view/controller/ChangeValueController.dart';
import 'package:EyuunApp/view/popup/ChangeValuePopup.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:EyuunApp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Talent.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:flutter/material.dart';

import '../DiceIcon.dart';

class TalentsWidget extends StatefulWidget {
  final List<TalentGroup> filter;
  final SkillLearnerComponent skillLearner;
  late final List<SkillEntry> display;
  TalentsWidget({super.key, required this.skillLearner, required this.filter}) {
    display = skillLearner.skills
        .where((x) => filter
            .contains(x.skill.getEntity()?.get<TalentComponent>()?.skillGroup))
        .toList();
  }

  @override
  State<TalentsWidget> createState() => _TalentsWidgetState();
}

class _TalentsWidgetState extends State<TalentsWidget> {
  final _textService = locator<TextService>();
  late final skillvalueController =
      SkillLearnerController(skillLearner: widget.skillLearner);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var talent in widget.display) _buildTalentDisplay(talent, context)
      ],
    );
  }

  Widget _buildTalentDisplay(SkillEntry talent, BuildContext context) {
    final theme = Theme.of(context);

    var talentAsset = locator<GameObjectService>().getStatic(talent.skill.id);
    final skillcheck = talentAsset?.get<SkillcheckComponent>();

    final attributes =
        locator<CharacterService>().character.get<AttributesComponent>()!;

    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Name
            Expanded(
              flex: 2,
              child: Text(
                _textService.getText(talent.skill.id),
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (skillcheck != null)
              Expanded(
                flex: 4,
                child: SkillCheckWidget(
                    skillcheck: skillcheck, attributes: attributes),
              ),
            // Value
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: skillvalueController.canSkill()
                    ? () {
                        ChangeValueController changeValController =
                            ChangeValueController(talent.value,
                                maxLimit: skillvalueController.getMax(),
                                minLimit: talent.value);
                        PopupUtil.popup(
                            context,
                            ChangeValuePopup(
                              changeValController,
                              valueChanged: (add) {
                                setState(() {
                                  skillvalueController.addSkillvalue(
                                      talentAsset, add);
                                });
                              },
                            ));
                        // handle tap
                      }
                    : null,
                child: Text(
                  "${talent.value}",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

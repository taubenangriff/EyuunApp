import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/ChangeValuePopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
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
import '../eyuun/EyuunWidgets.dart';

class TalentsWidget extends StatefulWidget {
  final List<TalentGroup> filter;
  SkillLearnerController skillLearnerController;
  late final List<SkillEntry> display;
  final VoidCallback? onTalentChanged;
  TalentsWidget({super.key, required this.skillLearnerController, required this.filter, this.onTalentChanged}) {
    display = skillLearnerController.skillLearner.skills
        .where((x) => filter
            .contains(x.skill.getEntity()?.get<TalentComponent>()?.skillGroup))
        .toList();
  }

  @override
  State<TalentsWidget> createState() => _TalentsWidgetState();
}

class _TalentsWidgetState extends State<TalentsWidget> {
  final _textService = locator<TextService>();

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

    return LayoutBuilder(builder: (context, constraints) {

      var hasEnaughWidth = constraints.maxWidth > 600;
      var useLong = constraints.maxWidth > 800;

      return Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name
              SizedBox(
                width: 150,
                child: Text(
                  _textService.getText(talent.skill.id),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              EyuunWidgets.spacerHorizontal(),
              // Value
              ElevatedButton(
                onPressed: widget.skillLearnerController.canSkill()
                    ? () {
                  ChangeValueController changeValController =
                  ChangeValueController(talent.value,
                      maxLimit: widget.skillLearnerController.getMax(),
                      minLimit: widget.skillLearnerController.getMin(talentAsset));
                  PopupUtil.popup(
                      context,
                      ChangeValuePopup(
                        changeValController,
                        valueChanged: (add) {
                          setState(() {
                            widget.skillLearnerController.addSkillvalue(
                                talentAsset, add);
                            widget.onTalentChanged?.call();
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
              Spacer(),
              if (skillcheck != null)
                SkillCheckWidget(
                    useWrap: true,
                    spacing: hasEnaughWidth ? 24 : 8,
                    iconSize: hasEnaughWidth ? 42 : 32,
                    showText: hasEnaughWidth,
                    useLongText: useLong,
                    skillcheck: skillcheck, attributes: attributes),
              Spacer(),
            ],
          ));
    });


  }
}

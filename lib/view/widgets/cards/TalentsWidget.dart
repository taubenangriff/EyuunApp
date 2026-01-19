import 'dart:math';

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
  final SkillLearnerController skillLearnerController;
  late final List<SkillEntry> display;
  final VoidCallback? onTalentChanged;
  TalentsWidget(
      {super.key,
      required this.skillLearnerController,
      required this.filter,
      this.onTalentChanged}) {
    display = skillLearnerController.skillLearner.skills
        .where((x) => filter
            .contains(x.skill.get<TalentComponent>()?.skillGroup))
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

    var talentAsset = talent.skill;
    final skillcheck = talentAsset.get<SkillcheckComponent>();

    final attributes =
        locator<CharacterService>().character.get<AttributesComponent>()!;

    const hideTextWidth = 600;
    const longTextWidth = 900;

    return LayoutBuilder(builder: (context, constraints) {
      var hasEnaughWidth = constraints.maxWidth > hideTextWidth;
      double boxWidth = max(10, min(constraints.maxWidth - hideTextWidth, 50));
      var useLong = constraints.maxWidth > longTextWidth;

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Name
              SizedBox(
                height: 60,
                width: hasEnaughWidth ? 150 : 140,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _textService.getTextFromEntity(talent.skill),
                      style: theme.textTheme.titleMedium,
                    )),
              ),
              EyuunWidgets.spacerHorizontal(),
              EyuunWidgets.circularFloatingActionButton(
                backgroundColor: widget.skillLearnerController.canSkill() ? Colors.blueGrey : theme.floatingActionButtonTheme.backgroundColor,
                text: "${talent.value}",
                onPressed: widget.skillLearnerController.canSkill()
                    ? () {
                  ChangeValueController changeValController =
                  ChangeValueController(talent.value,
                      maxLimit:
                      widget.skillLearnerController.getMax(),
                      minLimit: widget.skillLearnerController
                          .getMin(talentAsset),
                      onValUpdated: (val) =>
                          widget.skillLearnerController.setSkillvalue(
                              talent.skill, val));
                  PopupUtil.popup(
                      context,
                      ChangeValuePopup(
                        changeValController,
                        valueChanged: (add) {
                          setState(() {
                            changeValController.change(add);
                          });
                          widget.onTalentChanged?.call();
                        },
                      ));
                  // handle tap
                } : null,
                radius: 42,
              ),
              SizedBox(width: boxWidth),
              if (skillcheck != null && skillcheck.checkedAttributes.isNotEmpty)
                Expanded(
                    child: InkWell(
                        splashColor: Colors.red,
                        onTap: () {},
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: useLong ? 6 : 10),
                            child: Center(
                              child: SkillCheckWidget(
                                  useWrap: false,
                                  spacing: hasEnaughWidth ? 24 : 8,
                                  iconSize: hasEnaughWidth ? 42 : 32,
                                  showText: hasEnaughWidth,
                                  useLongText: useLong,
                                  skillcheck: skillcheck,
                                  attributes: attributes),
                            )))),
            ],
          ));
    });
  }
}

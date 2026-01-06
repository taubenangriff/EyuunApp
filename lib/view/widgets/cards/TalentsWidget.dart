import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Talent.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/TalentGroup.dart';
import 'package:flutter/material.dart';

import '../DiceIcon.dart';

class TalentsWidget extends StatefulWidget {
  final List<SkillEntry> talents;
  final List<TalentGroup> filter;
  late final List<SkillEntry> display;
  TalentsWidget({super.key, required this.talents, required this.filter}) {
    display = talents
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
                child: Row(
                  spacing: 46,
                  children: [
                    for (var attributeOption in skillcheck.checkedAttributes)
                      attributeOption.options.length > 1
                          ? SegmentedButton<String>(
                              multiSelectionEnabled: false,
                              emptySelectionAllowed: true,
                              segments: attributeOption.options
                                  .map((opt) => ButtonSegment(
                                        value: opt.id,
                                        label: _displayAttribute(
                                            opt.id, attributes),
                                      ))
                                  .toList(),
                              selected: {attributeOption.selectedOption.id},
                              onSelectionChanged: (newSelection) {
                                setState(() {
                                  attributeOption.selectedOption =
                                      attributeOption.options
                                          .where(
                                              (e) => e.id == newSelection.first)
                                          .first;
                                });
                              },
                            )
                          : _displayAttribute(
                              attributeOption.options.first.id, attributes)
                  ],
                ),
              )

            // Buttons (multiple segmented controls)
            ,

            // Value
            Expanded(
              flex: 1,
              child: Text(
                "${talent.value}",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _displayAttribute(String attribute, AttributesComponent attributes) {
    return Row(
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: 32),
            child: Text(_textService.getShort(attribute))),
        SizedBox(width: 12),
        DiceIcon(type: attributes.getStatEntry(attribute)!.dice)
      ],
    );
  }
}

import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:EyuunApp/view/widgets/DiceIcon.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

class TalentPage extends StatefulWidget {
  final double desiredSize;

  const TalentPage({super.key, this.desiredSize = 800});

  @override
  State<TalentPage> createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  final talents = locator<CharacterService>().character.get<SkillLearnerComponent>()?.skills ?? [];

  final Map<int, Map<int, String>> selectedValues = {};

  final _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.desiredSize),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              itemCount: talents.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, talentIndex) {
                final talent = talents[talentIndex];

                return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 46),
                    child: _buildTalentDisplay(talent, context));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayAttribute(String attribute, AttributesComponent attributes){
    return Row(
      children: [
        Text(_textService.getShort(attribute)),
        SizedBox(width: 12),
        DiceIcon(type: attributes.getStatEntry(attribute)!.dice)
      ],
    );
  }

  Row _buildTalentDisplay(SkillEntry talent, BuildContext context) {
    final theme = Theme.of(context);

    var talentAsset = locator<GameObjectService>().getStatic(talent.skill.id);
    final skillcheck = talentAsset?.get<SkillcheckComponent>();

    final attributes = locator<CharacterService>().character.get<AttributesComponent>()!;

    return Row(
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
            flex: 6,
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
                                    label: _displayAttribute(opt.id, attributes),
                                  ))
                              .toList(),
                          selected: { attributeOption.selectedOption.id },
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              attributeOption.selectedOption = attributeOption.options.where((e) => e.id == newSelection.first).first;
                            });
                          },
                        )
                      : _displayAttribute(attributeOption.options.first.id, attributes)
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
    );
  }
}

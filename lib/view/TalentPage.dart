import 'package:flutter/material.dart';

import '../components/Skillcheck.dart';
import '../core/registerServices.dart';
import '../core/services/TextService.dart';
import '../core/services/assetloader.dart';

class Talent {
  final String name;
  final int value;

  Talent(this.name, this.value);
}

class TalentPage extends StatefulWidget {
  final double desiredSize;

  const TalentPage({super.key, this.desiredSize = 800});

  @override
  State<TalentPage> createState() => _TalentPageState();
}

class _TalentPageState extends State<TalentPage> {
  final List<Talent> talents = [
    Talent("talent_athletic", 5),
    Talent("talent_sneaky", 5),
    Talent("talent_manipulation", 5),
    Talent("talent_investigate", 5),
  ];
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

  Row _buildTalentDisplay(Talent talent, BuildContext context) {
    final theme = Theme.of(context);

    var talentAsset = locator<AssetLoader>().getStatic(talent.name);
    final skillcheck = talentAsset?.get<SkillcheckComponent>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Name
        Expanded(
          flex: 2,
          child: Text(
            _textService.getText(talent.name),
            style: theme.textTheme.titleMedium,
          ),
        ),

        if (skillcheck != null)
          Expanded(
            flex: 6,
            child: Wrap(
              spacing: 32,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              children: [
                for (var attributeOption in skillcheck.checkedAttributes)
                  attributeOption.options.length > 1
                      ? SegmentedButton<String>(
                          multiSelectionEnabled: false,
                          emptySelectionAllowed: true,
                          segments: attributeOption.options
                              .map((opt) => ButtonSegment(
                                    value: opt,
                                    label: Text(_textService.getShort(opt)),
                                  ))
                              .toList(),
                          selected: {},
                          onSelectionChanged: (newSelection) {
                            setState(() {});
                          },
                        )
                      : Text(
                          _textService.getShort(attributeOption.options.first),
                          textAlign: TextAlign.center,)
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

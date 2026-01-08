import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import 'DiceIcon.dart';

class SkillCheckWidget extends StatefulWidget {
  final SkillcheckComponent skillcheck;
  final AttributesComponent attributes;

  final bool useWrap;
  final double iconSize;
  final double spacing;

  const SkillCheckWidget({super.key, required this.skillcheck, required this.attributes, this.useWrap = false, this.iconSize = 40, this.spacing = 46});

  @override
  State<SkillCheckWidget> createState() => _SkillCheckWidgetState();
}

class _SkillCheckWidgetState extends State<SkillCheckWidget> {
  final _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    var children = [
      for (var attributeOption in widget.skillcheck.checkedAttributes)
        attributeOption.options.length > 1
            ? SegmentedButton<String>(
          multiSelectionEnabled: false,
          emptySelectionAllowed: true,
          segments: attributeOption.options
              .map((opt) => ButtonSegment(
            value: opt.id,
            label: _displayAttribute(
                opt.id),
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
            attributeOption.options.first.id)
    ];

    if(widget.useWrap){
      return Wrap(children: children, runSpacing: 8);
    }

    return Row(
      spacing: widget.spacing,
      children: children,
    );
  }

  Widget _displayAttribute(String attribute) {
    return Row(
      children: [
        DiceIcon(type: widget.attributes.getStatEntry(attribute)!.dice, size: widget.iconSize),
        SizedBox(width: 4),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: 20),
            child: Text(_textService.getShort(attribute))),
        SizedBox(width: 4),
      ],
    );
  }
}

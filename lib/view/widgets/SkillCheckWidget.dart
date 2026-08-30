import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/DiceIcon.dart';

class SkillCheckWidget extends StatefulWidget {
  final SkillcheckComponent skillcheck;
  final AttributesComponent attributes;

  final bool useWrap;
  final double iconSize;
  final double spacing;
  final bool showText;
  final bool useLongText;

  const SkillCheckWidget(
      {super.key,
      required this.skillcheck,
      required this.attributes,
      this.useWrap = false,
      this.iconSize = 40,
      this.spacing = 46,
      this.showText = true,
      this.useLongText = false});

  @override
  State<SkillCheckWidget> createState() => _SkillCheckWidgetState();
}

class _SkillCheckWidgetState extends State<SkillCheckWidget> {
  final _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    var children = [
      for (var attributeOption in widget.skillcheck.checkedAttributes)
        _displayAttribute(context, attributeOption),
    ];

    if (widget.useWrap) {
      return Wrap(children: children, runSpacing: 8, spacing: widget.spacing);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: widget.spacing,
      children: children,
    );
  }

  Widget _displayAttribute(BuildContext context, SkillcheckOption attribute) {
    var theme = Theme.of(context);

    return Row(
      children: [
        if (attribute.numberOfDices > 1) ...{
          Text('${attribute.numberOfDices}x ',
              style: theme.textTheme.headlineSmall),
        },
        ...attribute.options
            .map((e) => [
                  Text(' / ', style: theme.textTheme.headlineSmall),
                  DiceIcon(
                      type: widget.attributes.getStatEntry(e.id)!.dice,
                      size: widget.iconSize),
                  if (widget.showText) ...{
                    SizedBox(width: 4),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: widget.useLongText ? 90 : 20),
                        child: Text(widget.useLongText
                            ? _textService.getText(e.id)
                            : _textService.getShort(e.id))),
                  }
                ])
            .expand((e) => e)
            .skip(1)
      ],
    );
  }
}

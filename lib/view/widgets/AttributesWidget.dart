import 'dart:math';

import 'package:flexbackend/view/widgets/DiceIcon.dart';
import 'package:flutter/material.dart';

import '../../components/Attributes.dart';
import '../../core/registerServices.dart';
import '../../core/services/CharacterService.dart';
import '../../core/services/TextService.dart';
import '../../enums/dice.dart';

class AttributesWidget extends StatefulWidget {
  const AttributesWidget({super.key});

  @override
  State<AttributesWidget> createState() => _AttributesWidgetState();
}

class _AttributesWidgetState extends State<AttributesWidget> {

  final _textService = locator<TextService>();

  List<AttributeEntry> attributes = locator<CharacterService>()
          .character
          .get<AttributesComponent>()
          ?.statValues ??
      [];

  Widget _buildBaseStatButton(BuildContext context, AttributeEntry item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 100, child: Text(_textService.getText(item.stat.id))),
        const SizedBox(width: 12),
        Padding(
            padding: const EdgeInsets.all(3),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  item.dice = Dice.values[Random().nextInt(Dice.values.length)];
                });
              },
              child: Center(child: DiceIcon(type: item.dice)),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = 50;
    final double crossAxisSpacing = 8;
    final int crossAxisCount = 2;

    var height = (attributes.length / crossAxisCount) * buttonHeight +
        3 * crossAxisSpacing;

    return Column(children: [
      Text(
        _textService.getText('text_attributes'),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: height, // or any height you want
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisExtent: buttonHeight,
          ),
          itemCount: attributes.length,
          itemBuilder: (context, index) =>
              _buildBaseStatButton(context, attributes[index]),
        ),
      )
    ]);
  }
}

import 'dart:math';

import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/controller/AttributesController.dart';
import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';


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

  final AttributesController _controller = AttributesController(
      locator<CharacterService>().character.get<AttributesComponent>() ??
          AttributesComponent());

  Widget _buildBaseStatButton(BuildContext context, AttributeEntry item) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main row (never shifts)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: DiceIcon(type: item.dice)),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: Text(_textService.getText(item.stat.id)),
            ),
          ],
        ),

        // Floating button (does not affect layout)
        if (_controller.upgradesPossible(item.stat.id))
          Positioned(
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _controller.increaseOneStep(item.stat.id);
                });
              },
              child: const Icon(Icons.upgrade),
            ),
          ),
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

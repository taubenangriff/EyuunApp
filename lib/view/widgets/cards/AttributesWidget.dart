import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/controller/AttributesController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_controller.upgradesPossible(item.stat.getTypeId()))
          SizedBox(width: 70, child: EyuunWidgets.circularFloatingActionButton(
            addDeco: true,
            onPressed: () {
              setState(() {
                _controller.increaseOneStep(item.stat.getTypeId());
              });
            },
            radius: 42,
            icon: Icons.upgrade
          ))
        else
          SizedBox(width: 70),
        EyuunWidgets.spacerHorizontal(),
        InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: DiceIcon(type: item.dice, size: 52)),
                EyuunWidgets.spacerHorizontal(),
                SizedBox(
                  width: 150,
                  child: Text(_textService.getTextFromEntity(item.stat)),
                ),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        _textService.getText('text_attributes'),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        child: GridView.builder(
          shrinkWrap: true, // so it fits inside other scrollables
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 600, // 👈 desired item width
            mainAxisExtent: 52,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: attributes.length,
          itemBuilder: (context, index) =>
              _buildBaseStatButton(context, attributes[index]),
        ),
      )
    ]);
  }
}

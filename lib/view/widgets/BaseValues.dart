import 'dart:math';

import 'package:flexbackend/view/widgets/DiceIcon.dart';
import 'package:flutter/material.dart';

import '../../components/BasicStats.dart';
import '../../core/registerServices.dart';
import '../../core/services/CharacterService.dart';
import '../../core/services/TextService.dart';
import '../../enums/dice.dart';

class BaseStatsWidget extends StatefulWidget {
  const BaseStatsWidget({super.key});

  @override
  State<BaseStatsWidget> createState() => _BaseStatsWidgetState();
}

class _BaseStatsWidgetState extends State<BaseStatsWidget> {

  final _textService = locator<TextService>();

  List<BasicStatEntry> baseStats = locator<CharacterService>()
          .character
          .get<BasicStatsComponent>()
          ?.statValues ??
      [];

  Widget _buildBaseStatButton(BuildContext context, BasicStatEntry item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 100, child: Text(_textService.getText(item.stat))),
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

    var height = (baseStats.length / crossAxisCount) * buttonHeight +
        3 * crossAxisSpacing;

    return Column(children: [
      const Text(
        'Attributes',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          itemCount: baseStats.length,
          itemBuilder: (context, index) =>
              _buildBaseStatButton(context, baseStats[index]),
        ),
      )
    ]);
  }
}

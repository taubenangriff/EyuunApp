import 'package:flexbackend/view/widgets/DiceIcon.dart';
import 'package:flutter/material.dart';

import '../../enums/dice.dart';

class BaseStatsWidget extends StatefulWidget {
  const BaseStatsWidget({super.key});

  @override
  State<BaseStatsWidget> createState() => _BaseStatsWidgetState();
}

class BaseValuePlaceholderItem {
  Dice dice;
  String name;

  BaseValuePlaceholderItem(this.dice, this.name);
}

class _BaseStatsWidgetState extends State<BaseStatsWidget> {
  List<BaseValuePlaceholderItem> baseStats = [
    BaseValuePlaceholderItem(Dice.d6, "Mut"),
    BaseValuePlaceholderItem(Dice.d8, "Intelligenz"),
    BaseValuePlaceholderItem(Dice.d12, "Intelligenz"),
    BaseValuePlaceholderItem(Dice.d6, "Intelligenz"),
    BaseValuePlaceholderItem(Dice.d8, "Intelligenz"),
    BaseValuePlaceholderItem(Dice.d6, "Intelligenz"),
    BaseValuePlaceholderItem(Dice.d10, "Intelligenz"),
    BaseValuePlaceholderItem(Dice.d12, "Intelligenz")
  ];

  Widget _buildBaseStatButton(
      BuildContext context, BaseValuePlaceholderItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 70, child: Text(item.name)),
        const SizedBox(width: 12),
        Padding(
            padding: const EdgeInsets.all(3),
            child: ElevatedButton(
              onPressed: () {
                debugPrint('Button pressed!');
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

    var height = (baseStats.length / crossAxisCount) * buttonHeight + 3*crossAxisSpacing ;

    return Column(
        children: [
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
              itemBuilder: (context, index) => _buildBaseStatButton(context, baseStats[index]),
            ),
          )
    ]);
  }
}

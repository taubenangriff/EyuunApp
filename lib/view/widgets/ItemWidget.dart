import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Holdable.dart';
import 'package:eyuuncore/components/Icon.dart';
import 'package:flutter/material.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:oxygen/oxygen.dart';

class InventoryItemWidget extends StatelessWidget {
  final Entity? entity;
  final int count;
  final bool isSelected;
  final VoidCallback? onTap;

  const InventoryItemWidget(
      {super.key,
      required this.entity,
      this.count = 1,
      this.isSelected = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildItemTile(context, isSelected: isSelected),
    );
  }

  Widget _buildItemTile(BuildContext context, {bool isSelected = false}) {
    if (entity == null) {
      return _buildEmptySlot(context);
    }

    var icon = entity?.get<IconComponent>()?.iconFilepath;

    final theme = Theme.of(context);

    return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: ArtDecoBoxDecoration(
            cornerBuilder: (p) => DoubleLineCornerPainter(p),
            verticalLineBuilder: (p) => DoubleLinePainter(p),
            horizontalLineBuilder: (p) => DoubleLinePainter(p),
            background: theme.canvasColor,
            paint: (isSelected
                ? Brushes.goldSparkling()
                : Brushes.silverSparkling())
              ..strokeWidth = 1.25,
            cornerSize: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 60, minHeight: 60),
          child: Center(
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: icon != null
                      ? Padding(
                          padding: EdgeInsets.all(12),
                          child: Image(
                              image: AssetImage(icon), width: 64, height: 64))
                      : const Icon(Icons.inventory_2, size: 32),
                ),
                if (count > 1)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'x$count',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (entity!.has<HoldableComponent>())
                          const Icon(Icons.back_hand, size: 16),
                        if (entity!.has<ArmorComponent>())
                          const Icon(Icons.shield, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildEmptySlot(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: ArtDecoBoxDecoration(
          cornerBuilder: (p) => DoubleLineCornerPainter(p),
          verticalLineBuilder: (p) => DoubleLinePainter(p),
          horizontalLineBuilder: (p) => DoubleLinePainter(p),
          background: theme.cardColor,
          paint: Paint()
            ..color = Colors.blueGrey
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.25,
          cornerSize: 12),
    );
  }
}

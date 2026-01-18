import 'package:eyuuncore/components/Icon.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:flutter/material.dart';
import 'eyuun/Brushes.dart';
import 'eyuun/EyuunDecoration.dart'; // for InventoryItem

class InventoryItemWidget extends StatelessWidget {
  final InventoryItem? item;
  final bool isSelected;
  final bool isDragging;
  final VoidCallback? onTap;

  const InventoryItemWidget(
      {super.key,
      required this.item,
      this.isSelected = false,
      this.isDragging = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if(item == null){
      return _buildItemTile(context, isSelected: isSelected);
    }
    return LongPressDraggable<InventoryItem>(
      hapticFeedbackOnStart: true,
      delay: const Duration(milliseconds: 100),
      data: item,
      feedback: _buildItemTile(context, isDragging: true),
      childWhenDragging: _buildEmptySlot(context),
      child: GestureDetector(
        onTap: onTap,
        child: _buildItemTile(context, isSelected: isSelected),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context,
      {bool isSelected = false, bool isDragging = false}) {
    if (item == null) {
      return _buildEmptySlot(context);
    }

    var entity = item?.object;
    var icon = entity?.get<IconComponent>()?.iconFilepath;

    final theme = Theme.of(context);

    return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: EyuunDecoration(
            cornerSize: isSelected ? 14 : 8,
            fillCorners: isSelected,
            background: theme.canvasColor,
            paint: isSelected
                ? Brushes.goldSparkling()
                : Brushes.silverSparkling()),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: icon != null ? Image(image: AssetImage(icon), width: 86, height: 86) : const Icon(Icons.inventory_2, size: 32),
                ),
                if (item!.count > 1)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'x${item!.count}',
                        style: const TextStyle(fontSize: 16),
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
      decoration: EyuunDecoration(
        background: theme.cardColor,
          paint: Paint()
            ..color = Colors.blueGrey
            ..style = PaintingStyle.stroke,
          cornerSize: 8,
          paintInnerLine: false,
          fillCorners: false),
    );
  }
}

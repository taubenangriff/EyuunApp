import 'package:flutter/material.dart';
import '../InventoryPage.dart'; // for InventoryItem

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
    return Draggable<InventoryItem>(
      data: item,
      feedback: _buildItemTile(context, isDragging: true),
      childWhenDragging: _buildEmptySlot(),
      child: GestureDetector(
        onTap: onTap,
        child: _buildItemTile(context, isSelected: isSelected),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context,
      {bool isSelected = false, bool isDragging = false}) {
    if (item == null) {
      return _buildEmptySlot();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade600,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isDragging
            ? Colors.grey.shade300
            : Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
        child: Center(
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Icon(Icons.inventory_2, size: 32),
              ),
              if (item!.count > 1)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'x${item!.count}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
    );
  }
}

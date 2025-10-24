import 'dart:math';
import 'package:flutter/material.dart';
import '../InventoryPage.dart';
import 'InventoryItemWidget.dart';

class InventoryWidget extends StatefulWidget {
  final List<InventoryItem> items;
  final ValueChanged<InventoryItem?>? onItemSelected;

  const InventoryWidget({
    super.key,
    required this.items,
    this.onItemSelected,
  });

  @override
  State<InventoryWidget> createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  late List<InventoryItem?> inventorySlots;
  InventoryItem? selectedItem;

  static const int columns = 6;
  static const int minSlots = 42;

  @override
  void initState() {
    super.initState();

    final total =
    max(((widget.items.length / columns).ceil() * columns), minSlots)
        .toInt();

    inventorySlots = List<InventoryItem?>.filled(total, null);
    for (int i = 0; i < widget.items.length; i++) {
      inventorySlots[i] = widget.items[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: inventorySlots.length,
      itemBuilder: (context, index) {
        final item = inventorySlots[index];

        return DragTarget<InventoryItem>(
          onAcceptWithDetails: (details) {
            final dragged = details.data;
            final oldIndex = inventorySlots.indexOf(dragged);
            setState(() {
              // Swap positions
              inventorySlots[oldIndex] = item;
              inventorySlots[index] = dragged;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return item == null
                ? _buildEmptySlot()
                : InventoryItemWidget(
              item: item,
              isSelected: selectedItem == item,
              onTap: () {
                setState(() => selectedItem = item);
                widget.onItemSelected?.call(item);
              },
            );
          },
        );
      },
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

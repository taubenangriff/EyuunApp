import 'dart:math';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/InventoryController.dart';
import 'package:flutter/material.dart';
import 'InventoryItemWidget.dart';

class InventoryWidget extends StatefulWidget {
  final InventoryComponent inventory;
  final ValueChanged<InventoryItem?>? onItemSelected;

  const InventoryWidget({
    super.key,
    required this.inventory,
    this.onItemSelected,
  });

  @override
  State<InventoryWidget> createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  late List<InventoryItem?> inventorySlots;
  InventoryItem? selectedItem;

  static const int columns = 6;
  static const int minSlots = 100;

  late var inventory = widget.inventory;
  late var inventoryController = InventoryController(inventory);

  @override
  void initState() {
    super.initState();

    final total =
    max(((inventory.maxCapacity / columns).ceil() * columns), minSlots)
        .toInt();

    inventorySlots = List<InventoryItem?>.filled(total, null);
    for (int i = 0; i < inventory.maxCapacity; i++) {
      inventorySlots[i] = inventory.getSlotItem(i);
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
              // Swap positions visually
              inventorySlots[oldIndex] = item;
              inventorySlots[index] = dragged;

              //call controller to swap in code.
              inventoryController.moveItem(oldIndex, index);
            });
          },
          builder: (context, candidateData, rejectedData) {
            return InventoryItemWidget(
              item: item,
              isSelected: selectedItem == item,
              onTap: () {
                setState(() => selectedItem = item);
                if(item == null)
                  return;
                widget.onItemSelected?.call(item);
              },
            );
          },
        );
      },
    );
  }
}

import 'package:eyuuncore/components/inventory.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/ItemWidget.dart';

class InventoryWidget extends StatefulWidget {
  final InventoryComponent inventory;
  InventoryItem? selectedItem;
  final ValueChanged<InventoryItem?>? onItemSelected;

  /// Invoked to actually place an item dragged from outside the inventory
  /// grid (e.g. an equipment slot) into [slotIndex]; owns all socketing logic.
  final void Function(InventoryItem item, int slotIndex)?
      onExternalItemAccepted;
  final double slotSize;

  InventoryWidget(
      {super.key,
      required this.inventory,
      this.onItemSelected,
      this.selectedItem,
      this.onExternalItemAccepted,
      this.slotSize = 100});

  @override
  State<InventoryWidget> createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  late List<InventoryItem?> inventorySlots;

  static const int minSlots = 100;

  late var inventory = widget.inventory;

  @override
  void initState() {
    super.initState();

    inventorySlots = List<InventoryItem?>.filled(minSlots, null);
    for (int i = 0; i < inventory.maxCapacity.current; i++) {
      inventorySlots[i] = inventory.getSlotItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    // re-sync from the source of truth: items can be removed/added by code
    // outside this widget (e.g. equipping/unequipping), which never goes
    // through this widget's own onAcceptWithDetails handler.
    for (int i = 0; i < inventory.maxCapacity.current; i++) {
      inventorySlots[i] = inventory.getSlotItem(i);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 300),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: widget.slotSize,
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
                // update the visual grid only; InventoryPage decides whether
                // this is a move within the inventory or an equip/unequip.
                if (oldIndex >= 0) {
                  inventorySlots[oldIndex] = item;
                }
                inventorySlots[index] = dragged;
              });

              widget.onExternalItemAccepted?.call(dragged, index);
            },
            builder: (context, candidateData, rejectedData) {
              if (item == null) {
                return const InventoryItemWidget(entity: null, count: 0);
              }

              return LongPressDraggable<InventoryItem>(
                hapticFeedbackOnStart: true,
                delay: const Duration(milliseconds: 100),
                data: item,
                feedback:
                    InventoryItemWidget(entity: item.object, count: item.count),
                childWhenDragging:
                    const InventoryItemWidget(entity: null, count: 0),
                child: InventoryItemWidget(
                  entity: item.object,
                  count: item.count,
                  isSelected: widget.selectedItem == item,
                  onTap: () {
                    widget.onItemSelected?.call(item);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

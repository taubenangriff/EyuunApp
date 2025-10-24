import 'dart:math';

import 'package:flexbackend/view/widgets/InventoryItemWidget.dart';
import 'package:flexbackend/view/widgets/InventoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class InventoryItem {
  String name;
  int count;
  String description;
  String category;

  InventoryItem(this.name, this.count, this.description, this.category);
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var random = Random();

  InventoryItem? selectedItem;

  InventoryItem? armor;
  InventoryItem? weapon;

  late List<InventoryItem> inventoryItems = List.generate(
      15,
      (index) => InventoryItem("ItemName", random.nextInt(10) + 1,
          loremIpsum(words: random.nextInt(150) + 10), "ItemCategory"));

  void _onItemSelected(InventoryItem? item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 1100;

    return Scaffold(
      body: Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: desiredSize),
              child: Row(
                children: [
                  // Left side: Inventory grid
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: InventoryWidget(
                        items: inventoryItems,
                        onItemSelected: _onItemSelected, // callback
                      ),
                    ),
                  ),
                  // Right side: Details panel
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: buildEquipmentSlot(
                                    label: "Armor",
                                    getItem: ()=> armor,
                                    setItem: (x) {armor = x; },
                                    onTap: () => setState(() {
                                      selectedItem = armor;
                                    }),
                                    onItemChanged: (newItem) => setState(() {
                                      if (newItem == null && selectedItem == armor) {
                                        selectedItem = null;
                                      }
                                      armor = newItem;
                                    }),
                                  ),
                                ),
                                const SizedBox(
                                    width: 8), // spacing between items
                                Expanded(
                                  child: buildEquipmentSlot(
                                    label: "Weapon",
                                    getItem: ()=> weapon,
                                    setItem: (x) {weapon = x; },
                                    onTap: () => setState(() {
                                      selectedItem = weapon;
                                    }),
                                    onItemChanged: (newItem) => setState(() {
                                      if (newItem == null && selectedItem == weapon) {
                                        selectedItem = null;
                                      }
                                      weapon = newItem;
                                    }),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withAlpha(150),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withAlpha(150),
                            ),
                          ),
                          child: selectedItem == null
                              ? _buildPlaceholder(theme)
                              : _buildItemDetails(
                                  context, selectedItem!, theme),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLargeFab(
            onPressed: () {},
            text: '1400 €',
            tooltip: 'Yuun',
            icon: Icons.money,
          ),
          const SizedBox(width: 16),
          _buildLargeFab(
            onPressed: () {},
            text: 'Add Item',
            tooltip: 'Add an Item',
            icon: Icons.add,
          )
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 200, maxHeight: 500),
        child: Center(
          child: Text(
            'Select an item to view details',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget _buildLargeFab(
      {required IconData icon,
      required VoidCallback onPressed,
      required String text,
      String tooltip = ""}) {
    return SizedBox(
        width: 120,
        height: 80,
        child: FloatingActionButton(
            heroTag: text,
            tooltip: tooltip,
            onPressed: onPressed,
            child: Row(
                mainAxisSize:
                    MainAxisSize.min, // 👈 prevents Row from stretching
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(icon, size: 36), Text(text)])));
  }

  Widget _buildItemDetails(
      BuildContext context, InventoryItem item, ThemeData theme) {
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: 400, maxHeight: size.height - 310),
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Count: ${item.count}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                item.category,
                style: theme.textTheme.bodyMedium,
              ),
              const Divider(height: 24),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Text(
                      item.description,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    )
                  ]))),
              SizedBox(height: 100)
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FloatingActionButton(
                  child: const Text('use item'),
                  onPressed: () => setState(() {})))
        ]));
  }

  Widget buildEquipmentSlot({
    required String label,
    required InventoryItem? Function() getItem,
    required void Function(InventoryItem?) setItem,
    required ValueChanged<InventoryItem?> onItemChanged,
    required VoidCallback onTap,
  }) {
    return
      AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Center(child: Text(label)),
            // The decorated box with your content
            DragTarget<InventoryItem>(
              builder: (context, candidateData,
                  rejectedData) =>
                  InventoryItemWidget(
                    item: getItem(),
                    onTap: () => setState(() {
                      selectedItem = getItem();
                    }),
                  ),
              onAcceptWithDetails: (details) {
                final dragged = details.data;
                setState(() {
                  setItem(dragged);
                });
              },
            ),
            if (getItem() != null)
            // The info button in the top right corner
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(
                      Icons.remove_circle),
                  tooltip: 'Unequip $label',
                  onPressed: () {
                    setState(() {
                      if(selectedItem == armor)
                        selectedItem = null;
                      setItem(null);
                    });
                  },
                ),
              ),
          ],
        )
      );
  }
}

import 'dart:math';

import 'package:flexbackend/view/widgets/InventoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class InventoryItem {
  String name;
  int count;
  String description;
  bool pinned;

  InventoryItem(this.name, this.count, this.description, this.pinned);
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var random = Random();

  InventoryItem? selectedItem;

  late List<InventoryItem> inventoryItems = List.generate(
      15,
      (index) => InventoryItem("ItemName", random.nextInt(10) + 1,
          loremIpsum(words: random.nextInt(30) + 5), false));

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
                    child: Container(
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
                          ? Center(
                              child: Text(
                                'Select an item to view details',
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : _buildItemDetails(selectedItem!, theme),
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

  Widget _buildItemDetails(InventoryItem item, ThemeData theme) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 500),
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
                'Pinned: ${item.pinned ? "Yes" : "No"}',
                style: theme.textTheme.bodyMedium,
              ),
              const Divider(height: 24),
              Text(
                item.description,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              )
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
}

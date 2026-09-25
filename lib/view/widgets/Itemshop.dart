import 'package:eyuunapp/view/widgets/ItemWidget.dart';
import 'package:eyuunapp/view/widgets/cards/ItemDisplayWidget.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/ShoppingController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ItemGridNavigator extends StatefulWidget {
  final List<Entity> rootItems;
  final InventoryComponent inventory;

  const ItemGridNavigator(
      {super.key, required this.rootItems, required this.inventory});

  @override
  State<ItemGridNavigator> createState() => _ItemGridNavigatorState();
}

class _ItemGridNavigatorState extends State<ItemGridNavigator> {
  late List<Entity> currentItems;
  final List<Entity> navigationStack = [];
  Entity? selectedItem;

  final _textService = locator<TextService>();
  late final _shoppingController = ShoppingController(widget.inventory);

  @override
  void initState() {
    super.initState();
    currentItems = widget.rootItems;
  }

  void navigateTo(Entity item) {
    if (item.has<AssetBundleComponent>()) {
      setState(() {
        selectedItem = null;
        navigationStack.add(item);
        currentItems = item.get<AssetBundleComponent>()!.getAssets();
      });
    } else {
      setState(() {
        selectedItem = item;
      });
    }
  }

  void navigateBackTo(int index) {
    setState(() {
      selectedItem = null;
      if (index == -1) {
        navigationStack.clear();
        currentItems = widget.rootItems;
      } else {
        navigationStack.removeRange(index + 1, navigationStack.length);
        currentItems =
            navigationStack.last.get<AssetBundleComponent>()!.getAssets();
      }
    });
  }

  void goBackOneLevel() {
    if (navigationStack.isNotEmpty) {
      navigateBackTo(navigationStack.length - 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            // Left side: item grid + breadcrumbs
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                                onPressed: goBackOneLevel,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text("Back")),
                            SizedBox(width: 30),
                            TextButton(
                              onPressed: () => navigateBackTo(-1),
                              child: const Text("All Items"),
                            ),
                            for (int i = 0;
                                i < navigationStack.length;
                                i++) ...[
                              const Icon(Icons.chevron_right, size: 18),
                              TextButton(
                                onPressed: () => navigateBackTo(i),
                                child: Text(_textService
                                    .getTextFromEntity(navigationStack[i])),
                              ),
                            ]
                          ],
                        )),
                  ),
                  // Main item grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 128, // 👈 desired item width
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85, // tweak if needed
                      ),
                      itemCount: currentItems.length,
                      itemBuilder: (context, index) {
                        final item = currentItems[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: InventoryItemWidget(
                                entity: item,
                                isSelected: selectedItem == item,
                                onTap: () => navigateTo(item),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _textService.getTextFromEntity(item),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Right panel: selected item display
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Stack(
                  children: [
                    Positioned.fill(
                      bottom: 80,
                      child: ItemDisplayWidget(
                        item: selectedItem == null
                            ? null
                            : InventoryItem.fromEntity(selectedItem!),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ElevatedButton.icon(
                        onPressed: selectedItem == null ||
                                !_shoppingController
                                    .canBuyItem(selectedItem!.getTypeId())
                            ? null
                            : () {
                                _shoppingController
                                    .buyItem(selectedItem!.getTypeId());
                                setState(() {});
                              },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Buy'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

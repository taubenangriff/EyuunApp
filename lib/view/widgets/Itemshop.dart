import 'package:eyuunapp/view/widgets/ItemWidget.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/cards/ItemDisplayWidget.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/components/Cost.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/ShoppingController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ItemGridNavigator extends StatefulWidget {
  final List<Entity> rootItems;
  final Entity entity;

  const ItemGridNavigator(
      {super.key, required this.rootItems, required this.entity});

  @override
  State<ItemGridNavigator> createState() => _ItemGridNavigatorState();
}

class _ItemGridNavigatorState extends State<ItemGridNavigator> {
  late List<Entity> currentItems;
  final List<Entity> navigationStack = [];
  Entity? selectedItem;

  final _textService = locator<TextService>();
  late final _shoppingController = ShoppingController(widget.entity);

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

  void _buyItem() {
    final item = selectedItem!;
    _shoppingController.buyItem(item.getTypeId());
    setState(() {});

    ElegantNotification.success(
      background: Theme.of(context).colorScheme.surface,
      title: Text(_textService.getText('uitext_item_bought_title')),
      description: Text(_textService.getText('uitext_item_bought_description',
          formatArgs: [_textService.getTextFromEntity(item)])),
    ).show(context);
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
                        childAspectRatio: 0.73, // tweak if needed
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
                            SizedBox(
                              height: 40,
                              child: Text(
                                _textService.getTextFromEntity(item),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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
              child: EyuunWidgets.cardBox(
                theme: Theme.of(context),
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
                          allowedActions: const {},
                        ),
                      ),
                      if (selectedItem != null &&
                          selectedItem!.has<CostComponent>())
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 64,
                          child: Center(
                            child: Text(
                              '${selectedItem!.get<CostComponent>()!.money} ¥',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _shoppingController
                                        .canBuyItem(selectedItem!.getTypeId())
                                    ? null
                                    : Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: EyuunWidgets.floatingActionButton(
                          icon: Icons.shopping_cart,
                          text: _textService.getText('item_buy'),
                          tooltip: _textService.getText('item_buy'),
                          onPressed: selectedItem == null ||
                                  !_shoppingController
                                      .canBuyItem(selectedItem!.getTypeId())
                              ? null
                              : _buyItem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/ChangeValuePopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/components/Icon.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/ShoppingController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ItemGridNavigator extends StatefulWidget {
  final List<Entity> rootItems;
  final InventoryComponent inventory;

  const ItemGridNavigator({super.key, required this.rootItems, required this.inventory});

  @override
  State<ItemGridNavigator> createState() => _ItemGridNavigatorState();
}

class _ItemGridNavigatorState extends State<ItemGridNavigator> {
  late List<Entity> currentItems;
  final List<Entity> navigationStack = [];
  Entity? selectedItem;

  int inInventoryCount = 11;

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
        selectedItem == null;
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
                        maxCrossAxisExtent:
                        128, // 👈 desired item width
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1, // tweak if needed
                      ),
                      itemCount: currentItems.length,
                      itemBuilder: (context, index) {
                        final item = currentItems[index];
                        return ElevatedButton(
                          onPressed: () => navigateTo(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.has<AssetBundleComponent>()
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              item.has<IconComponent>()
                                  ? Image(image: item.get<IconComponent>()!.getImage())
                                  : Icon(Icons.add, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                _textService.getTextFromEntity(item),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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
                child: selectedItem == null
                    ? const Center(child: Text("No item selected"))
                    : Stack(
                        children: [
                          Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              selectedItem?.has<IconComponent>() ?? false
                                  ? Image(image: selectedItem!.get<IconComponent>()!.getImage(), width: 128, height: 128)
                                  : Icon(Icons.add, size: 32),
                              const SizedBox(height: 16),
                              Text(
                                _textService.getTextFromEntity(selectedItem),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const Divider(),
                              Expanded(
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                Text(
                                  _textService.getFluffFromEntity(selectedItem),
                                  textAlign: TextAlign.justify,
                                )
                              ]))),
                              SizedBox(height: 110)
                            ],
                          )),
                          Positioned(
                            bottom: 6,
                            left: 0,
                            right: 0,
                            child: Column(children: [
                              Text('In Inventory: $inInventoryCount'),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: FloatingActionButton(
                                          child: const Text("x1"),
                                          onPressed: () {
                                            setState(() {
                                              if(selectedItem == null){
                                                return;
                                              }
                                              _shoppingController.buyItem(selectedItem!.getTypeId());
                                              inInventoryCount += 1;
                                            });
                                          })),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: FloatingActionButton(
                                          child: const Text("x10"),
                                          onPressed: () {
                                            setState(() {
                                              inInventoryCount += 10;
                                            });
                                          })),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: FloatingActionButton(
                                          child: const Text("xCustom"),
                                          onPressed: () {
                                            PopupUtil.popup(
                                                context,
                                                ChangeValuePopup(
                                                    ChangeValueController(
                                                        inInventoryCount,
                                                        minLimit:
                                                            inInventoryCount,
                                                        maxLimit: 100 +
                                                            inInventoryCount),
                                                    valueChanged: (val) {
                                                  setState(() {
                                                    inInventoryCount += val;
                                                  });
                                                }));
                                          })),
                                ],
                              )
                            ]),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ));
  }
}

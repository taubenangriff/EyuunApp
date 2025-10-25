import 'dart:math';

import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/popup/PopupUtil.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class Item {
  List<Item> children;
  String name;
  IconData icon;
  String description = loremIpsum(words: Random().nextInt(100) + 100);

  bool hasChildren() => children.isNotEmpty;

  Item(this.name, this.icon, [this.children = const []]);
}

class ItemGridNavigator extends StatefulWidget {
  final List<Item> rootItems;

  const ItemGridNavigator({super.key, required this.rootItems});

  @override
  State<ItemGridNavigator> createState() => _ItemGridNavigatorState();
}

class _ItemGridNavigatorState extends State<ItemGridNavigator> {
  late List<Item> currentItems;
  final List<Item> navigationStack = [];
  Item? selectedItem;

  int inInventoryCount = 11;

  @override
  void initState() {
    super.initState();
    currentItems = widget.rootItems;
  }

  void navigateTo(Item item) {
    if (item.hasChildren()) {
      setState(() {
        selectedItem == null;
        navigationStack.add(item);
        currentItems = item.children;
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
        currentItems = navigationStack.last.children;
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
                                child: Text(navigationStack[i].name),
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
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: currentItems.length,
                      itemBuilder: (context, index) {
                        final item = currentItems[index];
                        return ElevatedButton(
                          onPressed: () => navigateTo(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.hasChildren()
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                item.name,
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
                              Icon(selectedItem!.icon, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                selectedItem!.name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const Divider(),
                              Expanded(
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                Text(
                                  selectedItem!.description,
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

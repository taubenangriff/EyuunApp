import 'dart:math';

import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/popup/SelectItemPopup.dart';
import 'package:eyuunapp/view/widgets/InventoryItemWidget.dart';
import 'package:eyuunapp/view/widgets/InventoryWidget.dart';
import 'package:eyuunapp/view/widgets/cards/ItemDisplayWidget.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Holdable.dart';
import 'package:eyuuncore/components/feature/ItemShopFeature.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/CombatController.dart';
import 'package:eyuuncore/controller/InventoryController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/popup/MoneyChangePopup.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var random = Random();

  InventoryItem? selectedItem;

  InventoryItem? armor;

  List<InventoryItem?> holdables = [];

  InventoryItem? weapon;
  InventoryItem? secondWeapon;

  bool hasDragTarget = false;

  late InventoryComponent? _inventory;
  late CombatComponent? _combatComponent;

  late InventoryController _inventoryController;
  late CombatController _combatController;

  void _onItemSelected(InventoryItem? item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  void initState() {
    super.initState();

    _inventory =
        locator<CharacterService>().character.get<InventoryComponent>();
    _combatComponent =
        locator<CharacterService>().character.get<CombatComponent>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 1100;

    if (_inventory == null || _combatComponent == null) {
      return Container();
    }
    _inventoryController = InventoryController(_inventory!);
    _combatController = CombatController(_combatComponent!);

    holdables = _combatComponent?.equippedItems
            .map((item) => InventoryItem.fromEntity(item))
            .toList() ??
        [];



    List<Entity> shopItems = locator<ItemShopFeatureComponent>().getShopItems();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: desiredSize),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet =
                  constraints.maxWidth >= 900; // adjust breakpoint if needed

              double size = isTablet ? 100 : 80;

              List<Widget> slotWidgets = [
                for (var (index, _) in holdables.indexed) _buildHoldableSlot(index, size),
                if (_combatController.getFreeHands() > 0) _buildAddHoldableSlot(size),
                _buildArmorSlot(size),
              ];

              {
                // 📱 PHONE LAYOUT (vertical)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isTablet) ...{
                      Flexible(
                        flex: 3,
                        child: EyuunWidgets.eyuunBox(
                            child: ItemDisplayWidget(item: selectedItem),
                            theme: theme),
                      ),
                      EyuunWidgets.spacerVertical(),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: slotWidgets,
                      )
                    } else
                      Flexible(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🧾 Item display (left)
                            Expanded(
                              flex: 3,
                              child: EyuunWidgets.eyuunBox(
                                  child: ItemDisplayWidget(item: selectedItem),
                                  theme: theme),
                            ),
                            EyuunWidgets.spacerHorizontal(),
                            // 🛡 Armor slots (right)
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: slotWidgets,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    EyuunWidgets.spacerWidget(),
                    Flexible(
                      flex: 3,
                      child: EyuunWidgets.eyuunBox(
                          child: InventoryWidget(
                            inventory: _inventory!,
                            slotSize: isTablet ? 100 : 80,
                            onItemSelected: _onItemSelected,
                          ),
                          theme: theme),
                    ),
                    EyuunWidgets.spacerVertical(),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: _buildRemoveDragTarget()),
                          const SizedBox(width: 232),
                          Flexible(child: _buildGroupDragTarget())
                        ])
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_inventory != null)
            EyuunWidgets.circularFloatingActionButton(
              onPressed: () {
                final moneyController = ChangeValueController(_inventory!.money,
                    maxLimit: 99999,
                    minLimit: 0,
                    onValUpdated: (val) => _inventory!.money = val);
                PopupUtil.popup(
                    context,
                    MoneyChangePopup(moneyController, valueChanged: (change) {
                      setState(() {
                        moneyController.change(change);
                      });
                    }),
                    maximumSize: Size(400, 800));
              },
              text: '${_inventory!.money} €',
              tooltip: 'Yuun',
              icon: Icons.money,
            ),
          EyuunWidgets.spacerHorizontal(),
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () {
              PopupUtil.largePopup(
                  context,
                  ItemGridNavigator(
                      rootItems: shopItems, inventory: _inventory!),
                  header: locator<TextService>().getText('uitext_shop'),
                  background: AssetImage('data/base/ui/bg/background.jpg'));
            },
            text: 'Add Item',
            tooltip: 'Add an Item',
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  DragTarget<InventoryItem> _buildRemoveDragTarget() {
    return DragTarget<InventoryItem>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (details) {
        final draggedItem = details.data;
        setState(() {
          _inventoryController.deleteItem(draggedItem);
        });
      },
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 120,
          decoration: BoxDecoration(
            gradient: hovering
                ? LinearGradient(
                    colors: [
                      Colors.red.withAlpha(100), // deep red
                      Colors.transparent, // light pink-red tint
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )
                : const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  ),
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: hovering ? 1.0 : 0.8,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_forever, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DragTarget<InventoryItem> _buildGroupDragTarget() {
    return DragTarget<InventoryItem>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (details) {
        final draggedItem = details.data;
        setState(() {
          PopupUtil.largePopup(
              context,
              Padding(
                padding: EdgeInsets.all(32),
                child: Row(children: [
                  Expanded(
                      child: InventoryWidget(inventory: InventoryComponent())),
                  const Icon(Icons.swap_horiz, size: 52),
                  Expanded(
                      child: InventoryWidget(inventory: InventoryComponent()))
                ]),
              ));
        });
      },
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 120,
          decoration: BoxDecoration(
            gradient: hovering
                ? LinearGradient(
                    colors: [
                      Colors.transparent, // light pink-red tint
                      Colors.blue.withAlpha(100), // deep red
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  ),
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: hovering ? 1.0 : 0.8,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.transfer_within_a_station,
                      size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArmorSlot(double size) => _buildTypedEquipmentSlot(
        icon: Icons.shield_moon,
        getItem: () => armor,
        assignVisual: (x) => armor = x,
        acceptsEntity: (e) => e.has<ArmorComponent>(),
        canEquip: _combatController.canEquipArmor,
        equip: _combatController.equipArmor,
        unequip: _combatController.unequipArmor,
        onTap: () {
          if (armor != null) {
            setState(() => selectedItem = armor);
          }
        },
        size: size,
      );

  Widget _buildHoldableSlot(int index, double size) => _buildTypedEquipmentSlot(
        icon: Icons.back_hand,
        getItem: () => holdables[index],
        assignVisual: (x) => holdables[index] = x,
        acceptsEntity: (e) => e.has<HoldableComponent>(),
        canEquip: _combatController.canEquipHoldable,
        equip: (e) => _combatController.equipHoldable(e),
        unequip: () => _combatController.unequipHoldable(index),
        onTap: () {
          if (holdables[index] != null) {
            setState(() => selectedItem = holdables[index]);
          }
        },
        size: size,
      );

  Widget _buildAddHoldableSlot(double size) => _buildTypedEquipmentSlot(
        icon: Icons.back_hand,
        getItem: () => null,
        assignVisual: (x) {
          if (x != null) holdables.add(x);
        },
        acceptsEntity: (e) => e.has<HoldableComponent>(),
        canEquip: _combatController.canEquipHoldable,
        equip: (e) => _combatController.equipHoldable(e),
        unequip: () {},
        onTap: () => setState(() => selectedItem = null),
        size: size,
      );

  Widget _buildTypedEquipmentSlot(
      {required IconData icon,
      required InventoryItem? Function() getItem,
      required void Function(InventoryItem?) assignVisual,
      required bool Function(Entity entity) acceptsEntity,
      required bool Function(Entity entity) canEquip,
      required void Function(Entity entity) equip,
      required void Function() unequip,
      required VoidCallback onTap,
      required double size}) {
    return buildEquipmentSlot(
      size: size,
      icon: icon,
      getItem: getItem,
      setItem: (item) {
        // clear slot
        if (item == null) {
          unequip();
          assignVisual(null);
          return;
        }

        final entity = item.object;
        if (!acceptsEntity(entity)) return;
        if (!canEquip(entity)) return;

        equip(entity);
        _inventoryController.deleteItem(item);
        assignVisual(item);
      },
      onTap: onTap,
      onItemChanged: (newItem) => setState(() {
        if (newItem == null && selectedItem == getItem()) {
          selectedItem = null;
        }
        assignVisual(newItem);
      }),
    );
  }

  Widget buildEquipmentSlot(
      {required IconData icon,
      required InventoryItem? Function() getItem,
      required void Function(InventoryItem?) setItem,
      required ValueChanged<InventoryItem?> onItemChanged,
      required VoidCallback onTap,
      double size = 100}) {
    var item = getItem();
    return SizedBox(
        height: size,
        width: size,
        child: Stack(
          children: [
            // The decorated box with your content
            DragTarget<InventoryItem>(
              builder: (context, candidateData, rejectedData) =>
                  InventoryItemWidget(
                item: item,
                onTap: () => setState(() {
                  selectedItem = item;
                }),
              ),
              onAcceptWithDetails: (details) {
                final dragged = details.data;
                setState(() {
                  setItem(dragged);
                });
              },
            ),
            if (item == null) IgnorePointer(child: Center(child: Icon(icon))),
            if (item != null)
              // The info button in the top right corner
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  tooltip:
                      'Unequip ${locator<TextService>().getTextFromEntity(item.object)}',
                  onPressed: () {
                    setState(() {
                      if (selectedItem == armor) selectedItem = null;
                      setItem(null);
                    });
                  },
                ),
              ),
          ],
        ));
  }
}

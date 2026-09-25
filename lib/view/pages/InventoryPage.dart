import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/ConfirmDeleteItemPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/Itemshop.dart';
import 'package:eyuunapp/view/widgets/ItemWidget.dart';
import 'package:eyuunapp/view/widgets/InventoryWidget.dart';
import 'package:eyuunapp/view/widgets/cards/ItemDisplayWidget.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Holdable.dart';
import 'package:eyuuncore/components/feature/ItemShopFeature.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/CombatController.dart';
import 'package:eyuuncore/controller/InventoryController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/popup/MoneyChangePopup.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var random = Random();

  InventoryItem? selectedItem;

  InventoryItem? armor;

  Map<int, InventoryItem?> holdables = {};

  late Entity _entity;
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

  /// whether [item] currently sits in an equipment slot (armor or holdable).
  bool _isEquippedItem(InventoryItem item) =>
      armor == item || holdables.values.contains(item);

  /// Removes [item] from wherever it currently resides (armor, a holdable
  /// slot, or the inventory) so it can be placed somewhere else. Every move
  /// picks up its source this way, regardless of where it came from.
  void _pickUpItem(InventoryItem item) {
    if (armor == item) {
      _combatController.unequipArmor();
      armor = null;
      return;
    }

    for (final entry in holdables.entries) {
      if (entry.value == item) {
        _combatController.unequipHoldable(entry.key);
        holdables.remove(entry.key);
        return;
      }
    }

    _inventoryController.dropItem(item);
  }

  /// Places [item] into inventory slot [slotIndex]. If it was already in the
  /// player's inventory, it is simply moved; otherwise it is picked up from
  /// wherever it was equipped. Owns all item-socketing logic.
  void onInventoryItemAccepted(InventoryItem item, int slotIndex) {
    setState(() {
      final oldIndex = _inventoryController.getSlotIndexOfItem(item);
      if (oldIndex != null) {
        if (oldIndex == slotIndex) return;
        _inventoryController.moveItem(oldIndex, slotIndex);
        return;
      }

      if (!_inventoryController.isSlotFree(slotIndex)) return;

      _pickUpItem(item);
      _inventoryController.acceptItem(item, slotIndex);
    });
  }

  @override
  void initState() {
    super.initState();

    _entity = locator<CharacterService>().character;

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
    _combatController = CombatController(_entity);

    holdables = _combatComponent?.equippedItems ?? {};

    // keep the visual armor item in sync with the component, but avoid
    // recreating the InventoryItem instance when it hasn't actually changed.
    final armorEntity = _combatComponent?.armor;
    if (armorEntity == null) {
      armor = null;
    } else if (armor?.object != armorEntity) {
      armor = InventoryItem.fromEntity(armorEntity);
    }

    List<Entity> shopItems = locator<ItemShopFeatureComponent>().getShopItems();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: desiredSize),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet =
                  constraints.maxWidth >= 900; // adjust breakpoint if needed

              double size = isTablet ? 100 : 80;

              List<Widget> slotWidgets = [
                for (int i = 0;
                    i < _combatController.getEquipmentSlotCount();
                    i++)
                  _buildHoldableSlot(i, size),
                _buildArmorSlot(size),
              ];

              {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isTablet) ...[
                      // 📱 PHONE LAYOUT: item display, equipment slots, inventory slots stacked
                      Flexible(
                        flex: 1,
                        child: EyuunWidgets.cardBox(
                            child: ItemDisplayWidget(item: selectedItem),
                            theme: theme),
                      ),
                      EyuunWidgets.spacerVertical(),
                      EyuunWidgets.cardBox(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: slotWidgets,
                        ),
                        theme: theme,
                      ),
                      EyuunWidgets.spacerVertical(),
                      Expanded(
                        child: InventoryWidget(
                          inventory: _inventory!,
                          slotSize: 100,
                          onItemSelected: _onItemSelected,
                          onExternalItemAccepted: onInventoryItemAccepted,
                        ),
                      ),
                    ] else ...[
                      // 📱 TABLET LAYOUT: equipment+inventory column, item display column
                      Flexible(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  EyuunWidgets.cardBox(
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: slotWidgets,
                                    ),
                                    theme: theme,
                                  ),
                                  EyuunWidgets.spacerVertical(),
                                  Expanded(
                                    child: InventoryWidget(
                                      inventory: _inventory!,
                                      slotSize: 100,
                                      selectedItem: selectedItem,
                                      onItemSelected: _onItemSelected,
                                      onExternalItemAccepted:
                                          onInventoryItemAccepted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            EyuunWidgets.spacerHorizontal(),
                            EyuunWidgets.spacerHorizontal(),
                            Expanded(
                              flex: 2,
                              child: EyuunWidgets.cardBox(
                                child: ItemDisplayWidget(item: selectedItem),
                                theme: theme,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
      )),
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
                        locator<EventBus>().fire(EntityUpdatedEvent(
                            locator<CharacterService>().character,
                            _inventory!));
                      });
                    }),
                    maximumSize: Size(400, 800));
              },
              text: '${_inventory!.money} €',
              tooltip: locator<TextService>().getText('uitext_money'),
              icon: Icons.money,
            ),
          EyuunWidgets.spacerHorizontal(),
          EyuunWidgets.circularFloatingActionButton(
            onPressed: () async {
              await PopupUtil.largePopup(
                  context,
                  ItemGridNavigator(
                      rootItems: shopItems,
                      entity: locator<CharacterService>().character),
                  header: locator<TextService>().getText('uitext_shop'),
                  background: AssetImage('data/base/ui/bg/background.jpg'));
              setState(() {});
            },
            text: locator<TextService>().getText('uitext_add_item'),
            tooltip: locator<TextService>().getText('uitext_add_item_tooltip'),
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  DragTarget<InventoryItem> _buildRemoveDragTarget() {
    return DragTarget<InventoryItem>(
      onWillAcceptWithDetails: (details) => !_isEquippedItem(details.data),
      onAcceptWithDetails: (details) async {
        final draggedItem = details.data;
        final itemName =
            locator<TextService>().getTextFromEntity(draggedItem.object);
        final confirmed = await PopupUtil.popup<bool>(
            context, ConfirmDeleteItemPopup(itemName: itemName));
        if (confirmed != true) return;

        setState(() {
          _inventoryController.deleteItem(draggedItem);
          if (selectedItem == draggedItem) selectedItem = null;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete_forever,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    locator<TextService>().getText('uitext_delete'),
                    style: const TextStyle(
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

  Widget _buildGroupDragTarget() {
    return Expanded(child: Container());

    return DragTarget<InventoryItem>(
      onWillAcceptWithDetails: (details) => !_isEquippedItem(details.data),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.transfer_within_a_station,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    locator<TextService>().getText('uitext_group'),
                    style: const TextStyle(
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
        getItem: () => holdables.containsKey(index) ? holdables[index] : null,
        assignVisual: (x) =>
            holdables.containsKey(index) ? holdables[index] = x : null,
        acceptsEntity: (e) => e.has<HoldableComponent>(),
        canEquip: _combatController.canEquipHoldable,
        equip: (e) => _combatController.equipHoldable(index, e),
        unequip: () => _combatController.unequipHoldable(index),
        onTap: () {
          if (holdables[index] != null) {
            setState(() => selectedItem = holdables[index]);
          }
        },
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

        final displaced = getItem();
        if (displaced == item) return; // dropped onto its own slot

        int? freeSlot;
        if (displaced != null) {
          freeSlot = _inventoryController.getFirstFreeSlotIndex();
          if (freeSlot == -1) return; // no room to displace the occupant
        }

        // pick the dragged item up from wherever it currently is (another
        // equipment slot or the inventory) before placing it here.
        _pickUpItem(item);

        if (displaced != null) {
          unequip();
          _inventoryController.acceptItem(displaced, freeSlot!);
        }

        equip(entity);
        assignVisual(item);
      },
      onTap: onTap,
      onItemChanged: (newItem) => setState(() {
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
    final freeSlot = _inventoryController.getFirstFreeSlotIndex();
    return SizedBox(
        height: size,
        width: size,
        child: Stack(
          children: [
            // The decorated box with your content
            DragTarget<InventoryItem>(
              builder: (context, candidateData, rejectedData) {
                if (item == null) {
                  return const InventoryItemWidget(entity: null, count: 0);
                }

                return LongPressDraggable<InventoryItem>(
                  hapticFeedbackOnStart: true,
                  delay: const Duration(milliseconds: 100),
                  data: item,
                  feedback: InventoryItemWidget(
                      entity: item.object, count: item.count),
                  childWhenDragging:
                      const InventoryItemWidget(entity: null, count: 0),
                  child: InventoryItemWidget(
                    entity: item.object,
                    count: item.count,
                    isSelected: selectedItem == item ||
                        selectedItem?.object == item.object,
                    onTap: () => setState(() {
                      selectedItem = null;
                      selectedItem = item;
                    }),
                  ),
                );
              },
              onAcceptWithDetails: (details) {
                final dragged = details.data;
                setState(() {
                  setItem(dragged);
                });
              },
            ),
            if (item == null) IgnorePointer(child: Center(child: Icon(icon))),
            // hide the unequip button when there's nowhere in the inventory
            // to put the item; unequipping must never destroy it.
            if (item != null && freeSlot != -1)
              // The info button in the top right corner
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  tooltip: locator<TextService>().getText('uitext_unequip_item',
                      formatArgs: [
                        locator<TextService>().getTextFromEntity(item.object)
                      ]),
                  onPressed: () {
                    setState(() {
                      setItem(null);
                      _inventoryController.acceptItem(item, freeSlot);
                    });
                  },
                ),
              ),
          ],
        ));
  }
}

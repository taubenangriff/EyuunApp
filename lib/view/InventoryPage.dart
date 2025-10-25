import 'dart:math';

import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flexbackend/view/popup/ChangeItemCountPopup.dart';
import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/popup/PopupUtil.dart';
import 'package:flexbackend/view/popup/SelectItemPopup.dart';
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
  InventoryItem? secondWeapon;

  late List<InventoryItem> inventoryItems = List.generate(
      15,
      (index) => InventoryItem("ItemName", random.nextInt(10) + 1,
          loremIpsum(words: random.nextInt(150) + 10), "ItemCategory"));

  final List<Item> dummyItems = [
    Item("Weapons", Icons.security, [
      Item("Melee", Icons.abc_sharp, [
        Item("Longsword", Icons.gavel),
        Item("Dagger", Icons.cut),
        Item("Warhammer", Icons.construction),
        Item("Great Axe", Icons.fitness_center),
        Item("Spear", Icons.trending_up),
      ]),
      Item("Ranged", Icons.architecture, [
        Item("Shortbow", Icons.arrow_right_alt),
        Item("Crossbow", Icons.precision_manufacturing),
        Item("Throwing Knife", Icons.cut),
      ]),
      Item("Magical", Icons.auto_fix_high, [
        Item("Fire Wand", Icons.local_fire_department),
        Item("Ice Staff", Icons.ac_unit),
        Item("Lightning Rod", Icons.bolt),
      ]),
    ]),
    Item("Armor", Icons.shield, [
      Item("Light", Icons.checkroom, [
        Item("Leather Armor", Icons.hiking),
        Item("Padded Vest", Icons.backpack),
      ]),
      Item("Heavy", Icons.shield_moon, [
        Item("Plate Armor", Icons.shield),
        Item("Chainmail", Icons.grid_on),
        Item("Scale Armor", Icons.texture),
      ]),
      Item("Magical", Icons.auto_awesome, [
        Item("Robe of Protection", Icons.stars),
        Item("Cloak of Shadows", Icons.nightlight_round),
      ]),
    ]),
    Item("Potions", Icons.science, [
      Item("Healing", Icons.favorite, [
        Item("Minor Healing Potion", Icons.water_drop),
        Item("Major Healing Potion", Icons.water_drop),
      ]),
      Item("Buffs", Icons.flash_on, [
        Item("Potion of Strength", Icons.fitness_center),
        Item("Potion of Speed", Icons.directions_run),
        Item("Potion of Focus", Icons.psychology),
      ]),
      Item("Debuffs", Icons.warning, [
        Item("Poison Vial", Icons.sick),
        Item("Weakness Draught", Icons.local_drink),
      ]),
    ]),
    Item("Tools", Icons.build, [
      Item("Crafting", Icons.handyman, [
        Item("Hammer", Icons.handyman),
        Item("Tongs", Icons.tune),
        Item("Anvil", Icons.precision_manufacturing),
      ]),
      Item("Exploration", Icons.explore, [
        Item("Rope", Icons.settings_ethernet),
        Item("Torch", Icons.light_mode),
        Item("Pickaxe", Icons.landscape),
      ]),
    ]),
    Item("Magic", Icons.auto_fix_high, [
      Item("Offensive Spells", Icons.whatshot, [
        Item("Fireball", Icons.local_fire_department),
        Item("Frostbolt", Icons.ac_unit),
        Item("Arcane Missiles", Icons.blur_on),
      ]),
      Item("Defensive Spells", Icons.security, [
        Item("Barrier", Icons.shield),
        Item("Magic Ward", Icons.bubble_chart),
      ]),
      Item("Utility Spells", Icons.extension, [
        Item("Teleport", Icons.travel_explore),
        Item("Invisibility", Icons.visibility_off),
        Item("Levitate", Icons.flight),
      ]),
    ]),
    Item("Miscellaneous", Icons.category, [
      Item("Currency", Icons.monetization_on, [
        Item("Gold Coins", Icons.circle),
        Item("Silver Coins", Icons.circle_outlined),
      ]),
      Item("Quest Items", Icons.map, [
        Item("Ancient Relic", Icons.account_balance),
        Item("Sealed Letter", Icons.mail),
        Item("Royal Seal", Icons.verified),
      ]),
    ]),
  ];



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
                                  child: _buildArmorSlot(),
                                ),
                                const SizedBox(
                                    width: 8), // spacing between items
                                Expanded(
                                  child: _buildWeaponSlot(),
                                ),
                                const SizedBox(
                                    width: 8), // spacing between items
                                Expanded(
                                  child: _buildSecondWeaponSlot(),
                                ),
                              ],
                            )),
                        Expanded(child: _buildItemDetailWidget(theme))
                      ],
                    ),
                  )
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
            onPressed: () {
              PopupUtil.popup(context, ItemGridNavigator(rootItems: dummyItems), maximumSize: const Size(900, 700));
            },
            text: 'Add Item',
            tooltip: 'Add an Item',
            icon: Icons.add,
          )
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Center(
      child: Text(
        'Select an item to view details',
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
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

  Widget _buildItemDetailWidget(ThemeData theme) => Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(150),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(150),
          ),
        ),
        child: selectedItem == null
            ? _buildPlaceholder(theme)
            : _buildItemDetails(context, selectedItem!, theme),
      );

  Widget _buildItemDetails(
      BuildContext context, InventoryItem item, ThemeData theme) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
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
            top: 0,
            right: 0,
            child: ElevatedButton(
                child: Text('x${item.count}',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22)),
                onPressed: () {
                  var amountController = ChangeValueController(item.count,
                      name: "Item Count",
                      maxLimit: 64,
                      minLimit: 0,
                      onValUpdated: (val) => item.count = val);
                  setState(() {
                    PopupUtil.popup(
                        context,
                        ChangeItemCountPopup(amountController,
                            valueChanged: (change, useMoney) {
                          setState(() {
                            amountController.change(change);
                          });
                        }));
                  });
                }))
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 60, minWidth: 110),
          child: FloatingActionButton(
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hardware_outlined),
                    SizedBox(width: 4),
                    Text('Use')
                  ]),
              onPressed: () => setState(() {}))),
    );
  }

  Widget _buildArmorSlot() => buildEquipmentSlot(
        label: "Armor",
        getItem: () => armor,
        setItem: (x) {
          armor = x;
        },
        onTap: () => setState(() {
          selectedItem = armor;
        }),
        onItemChanged: (newItem) => setState(() {
          if (newItem == null && selectedItem == armor) {
            selectedItem = null;
          }
          armor = newItem;
        }),
      );

  Widget _buildWeaponSlot() => buildEquipmentSlot(
        label: "Weapon",
        getItem: () => weapon,
        setItem: (x) {
          weapon = x;
        },
        onTap: () => setState(() {
          selectedItem = weapon;
        }),
        onItemChanged: (newItem) => setState(() {
          if (newItem == null && selectedItem == weapon) {
            selectedItem = null;
          }
          weapon = newItem;
        }),
      );

  Widget _buildSecondWeaponSlot() => buildEquipmentSlot(
        label: "Weapon 2",
        getItem: () => secondWeapon,
        setItem: (x) {
          secondWeapon = x;
        },
        onTap: () => setState(() {
          selectedItem = secondWeapon;
        }),
        onItemChanged: (newItem) => setState(() {
          if (newItem == null && selectedItem == secondWeapon) {
            selectedItem = null;
          }
          secondWeapon = newItem;
        }),
      );

  Widget buildEquipmentSlot({
    required String label,
    required InventoryItem? Function() getItem,
    required void Function(InventoryItem?) setItem,
    required ValueChanged<InventoryItem?> onItemChanged,
    required VoidCallback onTap,
  }) {
    return AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Center(child: Text(label)),
            // The decorated box with your content
            DragTarget<InventoryItem>(
              builder: (context, candidateData, rejectedData) =>
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
                  icon: const Icon(Icons.remove_circle),
                  tooltip: 'Unequip $label',
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

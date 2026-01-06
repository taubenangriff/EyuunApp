import 'dart:math';

import 'package:EyuunApp/view/controller/ChangeValueController.dart';
import 'package:EyuunApp/view/popup/ChangeItemCountPopup.dart';
import 'package:EyuunApp/view/popup/ChangeValuePopup.dart';
import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:EyuunApp/view/popup/SelectItemPopup.dart';
import 'package:EyuunApp/view/widgets/InventoryItemWidget.dart';
import 'package:EyuunApp/view/widgets/InventoryWidget.dart';
import 'package:EyuunApp/view/widgets/eyuun/Brushes.dart';
import 'package:EyuunApp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:EyuunApp/view/widgets/cards/ItemDisplayWidget.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Holdable.dart';
import 'package:eyuuncore/components/Item.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/InventoryController.dart';
import 'package:eyuuncore/controller/CombatController.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/services/assetloader.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

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

  final List<Item> dummyItems = [
    Item("Weapons", Icons.security, [
      Item("Melee", Icons.sports_martial_arts, [
        Item("Longsword", Icons.gavel),
        Item("Dagger", Icons.cut),
        Item("Warhammer", Icons.construction),
        Item("Great Axe", Icons.fitness_center),
        Item("Spear", Icons.trending_up),
        Item("Halberd", Icons.stacked_line_chart),
        Item("Rapier", Icons.add_a_photo),
        Item("Morning Star", Icons.blur_on),
        Item("Mace", Icons.sports_kabaddi),
        Item("Katana", Icons.auto_awesome),
      ]),
      Item("Ranged", Icons.architecture, [
        Item("Shortbow", Icons.arrow_right_alt),
        Item("Crossbow", Icons.precision_manufacturing),
        Item("Throwing Knife", Icons.cut),
        Item("Longbow", Icons.trending_flat),
        Item("Javelin", Icons.send),
        Item("Sling", Icons.change_circle),
        Item("Repeating Crossbow", Icons.auto_fix_high),
        Item("Boomerang", Icons.refresh),
      ]),
      Item("Magical", Icons.auto_fix_high, [
        Item("Fire Wand", Icons.local_fire_department),
        Item("Ice Staff", Icons.ac_unit),
        Item("Lightning Rod", Icons.bolt),
        Item("Necromancer’s Skull", Icons.ad_units),
        Item("Crystal Scepter", Icons.crisis_alert),
        Item("Wand of Wonders", Icons.auto_awesome),
        Item("Arcane Orb", Icons.bubble_chart),
        Item("Chaos Focus", Icons.blur_on),
      ]),
    ]),
    Item("Armor", Icons.shield, [
      Item("Light", Icons.checkroom, [
        Item("Leather Armor", Icons.hiking),
        Item("Padded Vest", Icons.backpack),
        Item("Traveler’s Garb", Icons.hiking),
        Item("Scout Cloak", Icons.landscape),
        Item("Ranger Hood", Icons.park),
        Item("Shadow Wrap", Icons.nightlight_round),
        Item("Nomad Tunic", Icons.air),
      ]),
      Item("Heavy", Icons.shield_moon, [
        Item("Plate Armor", Icons.shield),
        Item("Chainmail", Icons.grid_on),
        Item("Scale Armor", Icons.texture),
        Item("Knight’s Guard", Icons.security),
        Item("Warplate", Icons.build_circle),
        Item("Bulwark Suit", Icons.shield_outlined),
        Item("Juggernaut Armor", Icons.iron),
      ]),
      Item("Magical", Icons.auto_awesome, [
        Item("Robe of Protection", Icons.stars),
        Item("Cloak of Shadows", Icons.nightlight_round),
        Item("Mantle of Flame", Icons.local_fire_department),
        Item("Frostweave Robe", Icons.ac_unit),
        Item("Celestial Aegis", Icons.cloud),
        Item("Runic Wrap", Icons.hexagon),
        Item("Ethereal Vestments", Icons.blur_on),
      ]),
    ]),
    Item("Potions", Icons.science, [
      Item("Healing", Icons.favorite, [
        Item("Minor Healing Potion", Icons.water_drop),
        Item("Major Healing Potion", Icons.water_drop),
        Item("Supreme Healing Potion", Icons.water_drop),
        Item("Restoration Draught", Icons.healing),
        Item("Rejuvenation Elixir", Icons.local_drink),
      ]),
      Item("Buffs", Icons.flash_on, [
        Item("Potion of Strength", Icons.fitness_center),
        Item("Potion of Speed", Icons.directions_run),
        Item("Potion of Focus", Icons.psychology),
        Item("Potion of Courage", Icons.military_tech),
        Item("Potion of Fortitude", Icons.shield),
        Item("Potion of Insight", Icons.visibility),
      ]),
      Item("Debuffs", Icons.warning, [
        Item("Poison Vial", Icons.sick),
        Item("Weakness Draught", Icons.local_drink),
        Item("Confusion Serum", Icons.loop),
        Item("Blinding Mist", Icons.blur_on),
      ]),
    ]),
    Item("Tools", Icons.build, [
      Item("Crafting", Icons.handyman, [
        Item("Hammer", Icons.handyman),
        Item("Tongs", Icons.tune),
        Item("Anvil", Icons.precision_manufacturing),
        Item("Chisel", Icons.construction),
        Item("File", Icons.file_present),
        Item("Saw", Icons.cut),
      ]),
      Item("Exploration", Icons.explore, [
        Item("Rope", Icons.settings_ethernet),
        Item("Torch", Icons.light_mode),
        Item("Pickaxe", Icons.landscape),
        Item("Compass", Icons.explore),
        Item("Lantern", Icons.lightbulb),
        Item("Map", Icons.map),
        Item("Climbing Kit", Icons.terrain),
      ]),
      Item("Farming", Icons.agriculture, [
        Item("Hoe", Icons.grass),
        Item("Scythe", Icons.grain),
        Item("Watering Can", Icons.water_drop),
        Item("Sickle", Icons.eco),
        Item("Plow", Icons.park),
        Item("Shovel", Icons.landscape),
      ]),
    ]),
    Item("Magic", Icons.auto_fix_high, [
      Item("Offensive Spells", Icons.whatshot, [
        Item("Fireball", Icons.local_fire_department),
        Item("Frostbolt", Icons.ac_unit),
        Item("Arcane Missiles", Icons.blur_on),
        Item("Chain Lightning", Icons.bolt),
        Item("Meteor", Icons.brightness_high),
        Item("Inferno Blast", Icons.local_fire_department),
      ]),
      Item("Defensive Spells", Icons.security, [
        Item("Barrier", Icons.shield),
        Item("Magic Ward", Icons.bubble_chart),
        Item("Absorb", Icons.shield_outlined),
        Item("Reflect", Icons.flip),
        Item("Stasis Field", Icons.pause_circle),
      ]),
      Item("Utility Spells", Icons.extension, [
        Item("Teleport", Icons.travel_explore),
        Item("Invisibility", Icons.visibility_off),
        Item("Levitate", Icons.flight),
        Item("Time Stop", Icons.access_time),
        Item("Dispel Magic", Icons.auto_fix_off),
        Item("Detect Magic", Icons.remove_red_eye),
      ]),
    ]),
    Item("Miscellaneous", Icons.category, [
      Item("Currency", Icons.monetization_on, [
        Item("Gold Coins", Icons.circle),
        Item("Silver Coins", Icons.circle_outlined),
        Item("Platinum Bars", Icons.rectangle),
        Item("Copper Nuggets", Icons.radio_button_checked),
        Item("Gemstones", Icons.diamond),
      ]),
      Item("Quest Items", Icons.map, [
        Item("Ancient Relic", Icons.account_balance),
        Item("Sealed Letter", Icons.mail),
        Item("Royal Seal", Icons.verified),
        Item("Crystal Fragment", Icons.crisis_alert),
        Item("Old Compass", Icons.explore_off),
      ]),
      Item("Collectibles", Icons.collections, [
        Item("Ancient Coin", Icons.currency_bitcoin),
        Item("Miniature Figurine", Icons.toys),
        Item("Lost Painting", Icons.image),
        Item("Rare Book", Icons.menu_book),
        Item("Antique Ring", Icons.ring_volume),
        Item("Broken Clock", Icons.access_time),
      ]),
    ]),
  ];

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
            .map((e) => InventoryItem.fromEntity(e.getEntity()))
            .toList() ??
        [];

    List<Widget> slotWidgets = [
      _buildArmorSlot(),
      for (var (index, _) in holdables.indexed) _buildHoldableSlot(index),
      if (_combatController.getFreeHands() > 0) _buildAddHoldableSlot()
    ];

    return Scaffold(
      body: Stack(
        children: [
          Center(
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
                        inventory: _inventory!,
                        onItemSelected: _onItemSelected,
                      ),
                    ),
                  ),
                  // Right side: Details panel
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                    128, // 👈 desired item width
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1, // tweak if needed
                              ),
                              itemCount: slotWidgets.length,
                              itemBuilder: (context, index) {
                                return slotWidgets[index];
                              },
                            )),
                        Expanded(child: ItemDisplayWidget(item: selectedItem)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: _buildRemoveDragTarget(),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _buildGroupDragTarget(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_inventory != null)
            _buildLargeFab(
              onPressed: () {
                final moneyController = ChangeValueController(_inventory!.money,
                    maxLimit: 99999,
                    minLimit: 0,
                    onValUpdated: (val) => _inventory!.money = val);
                PopupUtil.popup(
                    context,
                    ChangeValuePopup(moneyController, valueChanged: (change) {
                      setState(() {
                        moneyController.change(change);
                      });
                    }));
              },
              text: '${_inventory!.money} €',
              tooltip: 'Yuun',
              icon: Icons.money,
            ),
          const SizedBox(width: 16),
          _buildLargeFab(
            onPressed: () {
              PopupUtil.popup(
                context,
                ItemGridNavigator(rootItems: dummyItems),
                maximumSize: const Size(900, 700),
              );
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
          width: 200,
          decoration: BoxDecoration(
            gradient: hovering
                ? LinearGradient(
                    colors: [
                      Colors.red.withAlpha(100), // deep red
                      Colors.transparent, // light pink-red tint
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
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
              opacity: hovering ? 1.0 : 0.0,
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
          PopupUtil.popup(
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
              ),
              maximumSize: Size(900, 700));
        });
      },
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 200,
          decoration: BoxDecoration(
            gradient: hovering
                ? LinearGradient(
                    colors: [
                      Colors.transparent, // light pink-red tint
                      Colors.blue.withAlpha(100), // deep red
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
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
              opacity: hovering ? 1.0 : 0.0,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.transfer_within_a_station,
                      size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Access Group Items',
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


  Widget _buildLargeFab(
      {required IconData icon,
      required VoidCallback onPressed,
      required String text,
      String tooltip = ""}) {
    var color = Color(0xccfdcc3a);
    return SizedBox(
        width: 130,
        height: 90,
        child: DecoratedBox(
            decoration:
                EyuunDecoration(cornerSize: 12, paint: Brushes.goldSparkling()),
            position: DecorationPosition.foreground,
            child: FloatingActionButton(
                heroTag: text,
                tooltip: tooltip,
                onPressed: onPressed,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 36, color: color),
                      Text(text, style: TextStyle(color: color))
                    ]))));
  }

  Widget _buildArmorSlot() => buildEquipmentSlot(
        label: "Armor",
        getItem: () => armor,
        setItem: (x) {
          //clearing slot
          if (x == null) {
            _combatController.unequipArmor();
            armor = null;
            return;
          }
          //adding armor if x isn't null
          var armorEntity = x.object?.getEntity();
          if (armorEntity == null) {
            return;
          }
          if (!armorEntity.has<ArmorComponent>()) {
            return;
          }
          if (!_combatController.canEquipArmor(armorEntity)) {
            return;
          }
          _combatController.equipArmor(armorEntity);
          _inventoryController.deleteItem(x);

          //update visual armor
          armor = x;
        },
        onTap: () {
          if (armor == null) {
            return;
          }
          setState(() {
            selectedItem = armor;
          });
        },
        onItemChanged: (newItem) => setState(() {
          if (newItem == null && selectedItem == armor) {
            selectedItem = null;
          }
          armor = newItem;
        }),
      );

  Widget _buildHoldableSlot(int index) => buildEquipmentSlot(
        label: "Holdable",
        getItem: () => holdables[index],
        setItem: (x) {
          //clearing slot
          if (x == null) {
            _combatController.unequipHoldable(index);
            holdables[index] = null;
            return;
          }
          //adding holdable if x isn't null
          var holdableEntity = x.object?.getEntity();
          if (holdableEntity == null) {
            return;
          }
          if (!holdableEntity.has<HoldableComponent>()) {
            return;
          }
          if (!_combatController.canEquipHoldable(holdableEntity)) {
            return;
          }
          _combatController.equipHoldable(holdableEntity);
          _inventoryController.deleteItem(x);

          //update visual armor
          holdables[index] = x;
        },
        onTap: () {
          if (holdables[index] == null) {
            return;
          }
          setState(() {
            selectedItem = weapon;
          });
        },
        onItemChanged: (newItem) => setState(() {
          if (newItem == null && selectedItem == holdables[index]) {
            selectedItem = null;
          }
          holdables[index] = newItem;
        }),
      );

  Widget _buildAddHoldableSlot() => buildEquipmentSlot(
        label: "+",
        getItem: () => null,
        setItem: (x) {
          //clearing slot
          if (x == null) {
            _combatController.unequipArmor();
            armor = null;
            return;
          }
          //adding holdable if x isn't null
          var holdableEntity = x.object?.getEntity();
          if (holdableEntity == null) {
            return;
          }
          if (!holdableEntity.has<HoldableComponent>()) {
            return;
          }
          if (!_combatController.canEquipHoldable(holdableEntity)) {
            return;
          }
          _combatController.equipHoldable(holdableEntity);

          //update visual armor
          holdables.add(x);
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

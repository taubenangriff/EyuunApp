import 'dart:math';

import 'package:flexbackend/components/Item.dart';
import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flexbackend/view/popup/ChangeItemCountPopup.dart';
import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/popup/PopupUtil.dart';
import 'package:flexbackend/view/popup/SelectItemPopup.dart';
import 'package:flexbackend/view/widgets/InventoryItemWidget.dart';
import 'package:flexbackend/view/widgets/InventoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

import '../components/inventory.dart';
import '../components/text.dart';
import '../core/registerServices.dart';
import '../core/services/CharacterService.dart';
import '../core/services/TextService.dart';
import '../core/services/assetloader.dart';

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

  bool hasDragTarget = false;

  final _textService = locator<TextService>();
  final _assetLoader = locator<AssetLoader>();

  late InventoryComponent? _inventory;

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

    _inventory = locator<CharacterService>().character.get<InventoryComponent>();

    if(_inventory == null){
      return Container();
    }

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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(child: _buildArmorSlot()),
                              const SizedBox(width: 8),
                              Expanded(child: _buildWeaponSlot()),
                              const SizedBox(width: 8),
                              Expanded(child: _buildSecondWeaponSlot()),
                            ],
                          ),
                        ),
                        Expanded(child: _buildItemDetailWidget(theme)),
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
          _buildLargeFab(
            onPressed: () {},
            text: '1400 €',
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
                //remove the dragged item
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
                        Icon(Icons.delete_forever,
                            size: 48, color: Colors.white),
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
          PopupUtil.popup(context,
            Padding(padding: EdgeInsets.all(32), child: Row(children: [
              Expanded(child: InventoryWidget(inventory: InventoryComponent())),
              const Icon(Icons.swap_horiz, size: 52),
              Expanded(child: InventoryWidget(inventory: InventoryComponent()))
            ]),
            ),
            maximumSize: Size(900, 700)
          );
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

    final itemText = _assetLoader.getStatic(item.type.id)?.get<ItemComponent>()?.categoryText;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _textService.getTextFromLink(item.type),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _textService.getText(itemText ?? ""),
              style: theme.textTheme.bodyMedium,
            ),
            const Divider(height: 24),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              Text(
                _textService.getFluffFromLink(item.type),
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

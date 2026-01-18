import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class WeaponCraftingScreen extends StatefulWidget {
  const WeaponCraftingScreen({super.key});

  @override
  State<WeaponCraftingScreen> createState() => _WeaponCraftingScreenState();
}

class EntityHolder {
  final String name;
  final Entity? entity;
  final CraftDragType dragType;

  EntityHolder({
    required this.name,
    required this.entity,
    required this.dragType,
  });
}

enum CraftDragType {
  material,
  craftMethod,
  upgrade,
}

class CraftDragData<T> {
  final T value;
  final CraftDragType type;
  final int? fromUpgradeSlot; // only used for upgrades

  CraftDragData({
    required this.value,
    required this.type,
    this.fromUpgradeSlot,
  });
}

class _WeaponCraftingScreenState extends State<WeaponCraftingScreen> {
  EntityHolder? selectedMaterial;
  EntityHolder? selectedCraftMethod;
  final List<EntityHolder?> upgradeSlots = List.filled(3, null);

  var entity = locator<GameObjectService>().getStatic("path_flux_01_step_02")!;

  var weapon = locator<GameObjectService>().getStatic("smite_weapon_axe")!;

  late var skillcheck = weapon.get<SkillcheckComponent>();
  late var attributes =
      locator<CharacterService>().character.get<AttributesComponent>();

  late final materials = List.generate(
    4,
    (i) => EntityHolder(
      name: 'Material $i',
      entity: entity,
      dragType: CraftDragType.material,
    ),
  );

  late final craftMethods = List.generate(
    8,
    (i) => EntityHolder(
      name: 'Method $i',
      entity: entity,
      dragType: CraftDragType.craftMethod,
    ),
  );

  late final upgrades = List.generate(
    13,
    (i) => EntityHolder(
      name: 'Upgrade $i',
      entity: entity,
      dragType: CraftDragType.upgrade,
    ),
  );

  Entity? selectedEntityContext;
  Entity? selectedEquippedBuffContext;

  @override
  Widget build(BuildContext context) {
    weapon.get<WeaponComponent>()?.weaponType =
        AssetLink("weapontype_smiteweapon").getEntity();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 📑 Tabs
              const TabBar(
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Materials'),
                  Tab(text: 'Craft Method'),
                  Tab(text: 'Upgrades'),
                ],
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),

              // 🔄 Tab content
              Expanded(
                child: TabBarView(
                  children: [
                    const Center(child: Text('Weapon full overview')),
                    _buildMaterialView(),
                    _buildCraftMethodView(),
                    _buildUpgradesView(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ⚒ Craft button
              SizedBox(
                width: 200,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Text("Craft!"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _upgradeSlots(List<EntityHolder?> slots) {
    return List.generate(slots.length, (index) {
      return _draggableSlot(
        value: slots[index],
        label: slots[index]?.name ?? 'Upgrade Slot',
        onAccept: (data) {
          setState(() {
            if (data.fromUpgradeSlot != null) {
              final old = slots[index];
              slots[index] = data.value;
              slots[data.fromUpgradeSlot!] = old;
            } else {
              slots[index] = data.value;
            }
          });
        },
        onRemove: () => slots[index] = null,
        dragData: () => CraftDragData(
          type: CraftDragType.upgrade,
          value: slots[index],
          fromUpgradeSlot: index,
        ),
      );
    });
  }

  Widget _buildMaterialView() => _buildSelectionView(
        slot: _materialSlot(),
        list: _buildChoiceWrap(materials),
      );

  Widget _buildCraftMethodView() => _buildSelectionView(
        slot: _craftSlot(),
        list: _buildChoiceWrap(craftMethods),
      );

  Widget _buildUpgradesView() => Column(
        children: [
          Flexible(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _upgradeSlots(upgradeSlots),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('!Equipped Upgrade'),
          const SizedBox(height: 16),
          Flexible(child: BuffDisplay(buff: selectedEquippedBuffContext)),
          const Divider(),
          const SizedBox(height: 16),
          _sectionTitle('!Potential Upgrade'),
          const SizedBox(height: 16),
          Flexible(child: BuffDisplay(buff: selectedEntityContext)),
          const SizedBox(height: 16),
          SizedBox(height: 170, child: _buildChoiceWrap(upgrades)),
        ],
      );

  Widget _buildSelectionView({
    required Widget slot,
    required Widget list,
  }) {
    return Column(
      children: [
        Flexible(child: slot),
        const SizedBox(height: 16),
        _sectionTitle('!Equipped Upgrade'),
        const SizedBox(height: 16),
        Flexible(child: BuffDisplay(buff: selectedEquippedBuffContext)),
        const Divider(),
        const SizedBox(height: 16),
        _sectionTitle('!Potential Upgrade'),
        const SizedBox(height: 16),
        Flexible(child: BuffDisplay(buff: selectedEntityContext)),
        const SizedBox(height: 16),
        SizedBox(height: 170, child: list),
      ],
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      );

  Widget _draggableSlot({
    required EntityHolder? value,
    required void Function(CraftDragData<EntityHolder?>) onAccept,
    required VoidCallback onRemove,
    required CraftDragData<EntityHolder?> Function() dragData,
    required String label,
  }) {
    return DragTarget<CraftDragData<EntityHolder?>>(
      onAcceptWithDetails: (d) => setState(() => onAccept(d.data)),
      builder: (_, __, ___) {
        final slot = _slotBox(label: label, context: value?.entity);

        if (value == null) return slot;

        return Draggable<CraftDragData<EntityHolder?>>(
          data: dragData(),
          feedback: Material(color: Colors.transparent, child: slot),
          childWhenDragging: Opacity(opacity: 0.4, child: slot),
          child: slot,
          onDragEnd: (d) {
            if (!d.wasAccepted) setState(onRemove);
          },
        );
      },
    );
  }

  Widget _materialSlot() => _draggableSlot(
        value: selectedMaterial,
        onAccept: (d) => selectedMaterial = d.value,
        onRemove: () => selectedMaterial = null,
        dragData: () => CraftDragData(
          type: CraftDragType.material,
          value: selectedMaterial,
        ),
        label: selectedMaterial?.name ?? 'Material Slot',
      );

  Widget _craftSlot() => _draggableSlot(
        value: selectedCraftMethod,
        onAccept: (d) => selectedCraftMethod = d.value,
        onRemove: () => selectedCraftMethod = null,
        dragData: () => CraftDragData(
          type: CraftDragType.craftMethod,
          value: selectedCraftMethod,
        ),
        label: selectedCraftMethod?.name ?? 'Method Slot',
      );

  Widget _buildChoiceWrap(List<EntityHolder> items) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) {
          return Draggable<CraftDragData<EntityHolder>>(
            data: CraftDragData(
              value: item,
              type: item.dragType,
            ),
            feedback: _slotTile(item.name, dragging: true),
            child: _slotTile(item.name, context: item.entity),
          );
        }).toList(),
      ),
    );
  }

  Widget _slotTile(String label, {bool dragging = false, Entity? context}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedEntityContext = context;
          });
        },
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: dragging ? Colors.grey.shade600 : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ));
  }

  Widget _slotBox({required String label, required Entity? context}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedEquippedBuffContext = context;
          });
        },
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label),
        ));
  }
}

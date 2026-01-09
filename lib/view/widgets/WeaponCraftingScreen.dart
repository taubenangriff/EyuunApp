import 'package:EyuunApp/view/widgets/BalancedWrap.dart';
import 'package:EyuunApp/view/widgets/BuffDisplay.dart';
import 'package:EyuunApp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class WeaponCraftingScreen extends StatefulWidget {
  const WeaponCraftingScreen({super.key});

  @override
  State<WeaponCraftingScreen> createState() => _WeaponCraftingScreenState();
}

abstract class EntityHolder {
  String name;
  Entity? entity;
  EntityHolder(this.name, this.entity);
}

class MaterialDef extends EntityHolder {
  MaterialDef(super.name, super.entity);
}

class CraftMethodDef extends EntityHolder {
  CraftMethodDef(super.name, super.entity);
}

class UpgradeDef extends EntityHolder {
  UpgradeDef(super.name, super.entity);
}

class UpgradeDragData {
  final UpgradeDef upgrade;
  final int? fromSlotIndex; // null = from inventory

  UpgradeDragData({
    required this.upgrade,
    this.fromSlotIndex,
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
  MaterialDef? selectedMaterial;
  CraftMethodDef? selectedCraftMethod;
  final List<UpgradeDef?> upgradeSlots = List.filled(3, null);

  var entity = locator<GameObjectService>().getStatic("path_flux_01_step_02")!;

  var weapon = locator<GameObjectService>().getStatic("smite_weapon_axe")!;

  late var skillcheck = weapon.get<SkillcheckComponent>();
  late var attributes =
      locator<CharacterService>().character.get<AttributesComponent>();

  // demo data
  late final materials =
      List.generate(4, (i) => MaterialDef('Material $i', entity));
  late final craftMethods =
      List.generate(8, (i) => CraftMethodDef('Method $i', entity));
  late final upgrades =
      List.generate(13, (i) => UpgradeDef('Upgrade $i', entity));

  Entity? selectedEntityContext;

  @override
  Widget build(BuildContext context) {


    weapon.get<WeaponComponent>()?.weaponType = AssetLink("weapontype_smiteweapon");

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 📑 Tabs
              const TabBar(
                tabs: [
                  Tab(text: 'Materials'),
                  Tab(text: 'Craft Method'),
                  Tab(text: 'Upgrades'),
                ],
              ),
              // 🧱 Weapon section (always visible)
              Expanded(
                child: Center(
                  child: _buildWeaponSection(),
                ),
              ),

              const SizedBox(height: 12),
              const SizedBox(height: 12),

              // 🔄 Tab content
              SizedBox(
                height: 170,
                child: TabBarView(
                  children: [
                    _buildMaterialList(),
                    _buildCraftMethodList(),
                    _buildUpgradeGrid(),
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

  Widget _buildCraftMethodList() => _buildChoiceWrap<CraftMethodDef>(craftMethods);

  Widget _buildMaterialList() => _buildChoiceWrap<MaterialDef>(materials);

  Widget _buildUpgradeGrid() => _buildChoiceWrap<UpgradeDef>(upgrades);

  Widget _buildWeaponSection() {
    var slots = List.generate(upgradeSlots.length, (index) {
      return _draggableSlot<UpgradeDef?>(upgradeSlots[index], (data) {
        setState(() {
          // swap if coming from another slot
          if (data.fromUpgradeSlot != null) {
            final old = upgradeSlots[index];
            upgradeSlots[index] = data.value;
            upgradeSlots[data.fromUpgradeSlot!] = old;
          } else {
            // from inventory
            upgradeSlots[index] = data.value;
          }
        });
      },
          () => upgradeSlots[index] = null,
          () => CraftDragData(
              type: CraftDragType.upgrade,
              value: upgradeSlots[index],
              fromUpgradeSlot: index),
          upgradeSlots[index]?.name ?? "Upgrade Slot");
    });

    var allSlots = [_materialSlot(), _craftSlot()] + slots;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '!Weapon',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              if (skillcheck != null && attributes != null)
                SkillCheckWidget(
                    skillcheck: skillcheck!,
                    attributes: attributes!,
                    iconSize: 32,
                    spacing: 16),
              const SizedBox(width: 40),
              Text(locator<TextService>().getTextFromLink(weapon.get<WeaponComponent>()?.fightingType))
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '!Weapon Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          BuffDisplay(
              buff: weapon.get<WeaponComponent>()?.weaponType?.getEntity()),
          Spacer(),
          const SizedBox(height: 16),
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: allSlots,
            ),
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 8),
          const Text(
            '!Upgrade',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
              height: 100, child: BuffDisplay(buff: selectedEntityContext)),
        ],
      ),
    );
  }

  Widget _draggableSlot<T extends EntityHolder?>(
      T definition,
      void Function(CraftDragData<T>) setValueCallback,
      void Function() removeValueCallback,
      CraftDragData<T> Function() createCraftDragData,
      String name) {
    return DragTarget<CraftDragData<T>>(
      onAcceptWithDetails: (details) =>
          setState(() => setValueCallback.call(details.data)),
      builder: (_, __, ___) {
        var slotbox = _slotBox(label: name, context: definition?.entity);

        if (definition == null) {
          return slotbox;
        }

        return Draggable<CraftDragData<T>>(
          data: createCraftDragData.call(),
          feedback: Material(
            color: Colors.transparent,
            child: slotbox,
          ),
          childWhenDragging: Opacity(
            opacity: 0.4,
            child: slotbox,
          ),
          child: slotbox,
          onDragEnd: (details) {
            // dropped nowhere → remove
            if (!details.wasAccepted) {
              setState(() {
                removeValueCallback.call();
              });
            }
          },
        );
      },
    );
  }

  Widget _craftSlot() => _draggableSlot<CraftMethodDef?>(
      selectedCraftMethod,
      (data) => selectedCraftMethod = data.value,
      () => selectedCraftMethod = null,
      () => CraftDragData(
          type: CraftDragType.craftMethod, value: selectedCraftMethod),
      selectedCraftMethod?.name ?? 'Method Slot');

  Widget _materialSlot() => _draggableSlot<MaterialDef?>(
      selectedMaterial,
      (data) => selectedMaterial = data.value,
      () => selectedMaterial = null,
      () =>
          CraftDragData(type: CraftDragType.material, value: selectedMaterial),
      selectedMaterial?.name ?? 'Material Slot');

  Widget _buildChoiceWrap<T extends EntityHolder>(List<T> items) {
    return SingleChildScrollView(child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: items.map((upg) {
      return Draggable<CraftDragData<T>>(
        data: CraftDragData(
          value: upg,
          type: CraftDragType.craftMethod,
        ),
        feedback: _slotTile(upg.name, dragging: true),
        child: _slotTile(upg.name, context: upg.entity),
      );
    }).toList()));
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
            selectedEntityContext = context;
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

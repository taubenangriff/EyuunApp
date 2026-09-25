import 'package:eyuunapp/view/widgets/ActionDisplay.dart';
import 'package:eyuunapp/view/widgets/ItemDisplay.dart';
import 'package:eyuunapp/view/widgets/WeaponCraftingScreen.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Craftable.dart';
import 'package:eyuuncore/components/Holdable.dart';
import 'package:eyuuncore/components/Item.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/popup/ChangeItemCountPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

enum ItemDisplayAction { equipArmor, equipHoldable, craft, changeCount }

class ItemDisplayWidget extends StatefulWidget {
  final InventoryItem? item;
  final Set<ItemDisplayAction> allowedActions;
  const ItemDisplayWidget(
      {super.key,
      required this.item,
      this.allowedActions = const {
        ItemDisplayAction.equipArmor,
        ItemDisplayAction.equipHoldable,
        ItemDisplayAction.craft,
        ItemDisplayAction.changeCount,
      }});

  @override
  State<ItemDisplayWidget> createState() => _ItemDisplayWidgetState();
}

class _ItemDisplayWidgetState extends State<ItemDisplayWidget> {
  final _textService = locator<TextService>();
  final _gameObjectService = locator<GameObjectService>();

  @override
  Widget build(BuildContext context) {
    return widget.item == null
        ? _buildPlaceholder(context)
        : _buildItemDetails(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Select an item to view details',
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildItemDetails(context) {
    final theme = Theme.of(context);

    var item = widget.item!;

    final itemText = item.object.get<ItemComponent>()?.categoryText;

    final actionButtons = _buildActionButtons(context, item);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _textService.getTextFromEntity(item.object),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _textService.getText(itemText ?? ""),
                style: theme.textTheme.bodyMedium,
              ),
              EyuunWidgets.spacerVertical(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _withSpacers(actionButtons)),
              EyuunWidgets.spacerVertical(),
              const Divider(height: 4),
              Expanded(
                  child: SingleChildScrollView(
                      child:
                          Column(children: [ItemDisplay(item: item.object)]))),
            ],
          ),
        ]));
  }

  List<Widget> _withSpacers(List<Widget> buttons) {
    final result = <Widget>[];
    for (var button in buttons) {
      if (result.isNotEmpty) {
        result.add(EyuunWidgets.spacerHorizontal());
      }
      result.add(button);
    }
    return result;
  }

  List<Widget> _buildActionButtons(BuildContext context, InventoryItem item) {
    return [
      if (widget.allowedActions.contains(ItemDisplayAction.craft) &&
          (widget.item?.object.has<CraftableComponent>() ?? false))
        EyuunWidgets.circularFloatingActionButton(
            icon: Icons.handyman,
            radius: 42,
            addDeco: true,
            onPressed: () => setState(() {
                  PopupUtil.largePopup(context, WeaponCraftingScreen(),
                      background: AssetImage('data/base/ui/bg/background.jpg'));
                })),
      if (widget.allowedActions.contains(ItemDisplayAction.changeCount))
        EyuunWidgets.circularFloatingActionButton(
            radius: 42,
            addDeco: true,
            text: 'x${item.count}',
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
            }),
    ];
  }
}

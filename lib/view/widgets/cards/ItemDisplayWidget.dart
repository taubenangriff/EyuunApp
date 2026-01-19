import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Item.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../../controller/ChangeValueController.dart';
import '../../popup/ChangeItemCountPopup.dart';
import '../../popup/PopupUtil.dart';
import '../eyuun/Brushes.dart';
import '../eyuun/EyuunDecoration.dart';
import '../eyuun/EyuunWidgets.dart';

class ItemDisplayWidget extends StatefulWidget {
  final InventoryItem? item;
  const ItemDisplayWidget({super.key, required this.item});

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
                  _textService.getFluffFromEntity(item.object),
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
              child: EyuunWidgets.circularFloatingActionButton(
                  radius: 52,
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
                  }))
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
          if (widget.item?.object.has<ArmorComponent>() ?? false) ...{
            const SizedBox(height: 16),
            EyuunWidgets.floatingActionButton(
                icon: Icons.shield,
                text: 'Equip',
                onPressed: () => setState(() {}),
                height: 60,
                width: 130),
          },
          if (widget.item?.object.has<WeaponComponent>() ?? false) ...{
            const SizedBox(height: 16),
            EyuunWidgets.floatingActionButton(
                icon: Icons.abc,
                text: 'Equip',
                onPressed: () => setState(() {}),
                height: 60,
                width: 130),
          }
        ]));
  }
}

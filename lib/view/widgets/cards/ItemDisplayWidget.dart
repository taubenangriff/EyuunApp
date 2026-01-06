import 'package:eyuuncore/components/Item.dart';
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

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration:
      EyuunDecoration(cornerSize: 20, paint: Brushes.goldSparkling()),
      child: widget.item == null
          ? _buildPlaceholder(context)
          : _buildItemDetails(context),
    );
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

    final itemText = _gameObjectService
        .getStatic(item.type.id)
        ?.get<ItemComponent>()
        ?.categoryText;

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
}
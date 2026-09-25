import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteItemPopup extends StatelessWidget {
  const ConfirmDeleteItemPopup({required this.itemName, super.key});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textService.getText('uitext_confirm_delete_item_header'),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            textService
                .getText('uitext_confirm_delete_item', formatArgs: [itemName]),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EyuunWidgets.floatingActionButton(
                text: textService.getText('uitext_no'),
                width: 100,
                height: 40,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              EyuunWidgets.floatingActionButton(
                text: textService.getText('uitext_yes'),
                width: 100,
                height: 40,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

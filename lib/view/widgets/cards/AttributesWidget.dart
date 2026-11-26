import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/controller/AttributesUpgradeController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

class AttributesWidget extends StatefulWidget {
  final AttributesUpgradeController? controller;

  const AttributesWidget({
    super.key,
    required this.controller,
  });

  @override
  State<AttributesWidget> createState() => _AttributesWidgetState();
}

class _AttributesWidgetState extends State<AttributesWidget> {
  Widget _buildStat(AttributeEntry item, TextService textService) {
    final controller = widget.controller!;
    final statId = item.stat.getTypeId();
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: controller.canDecrease(statId)
              ? EyuunWidgets.circularFloatingActionButton(
                  icon: Icons.keyboard_arrow_left_rounded,
                  radius: 38.0,
                  tooltip: textService.getText('uitext_attribute_decrease'),
                  onPressed: () {
                    setState(() => controller.decrease(statId));
                  },
                )
              : null,
        ),
        DiceIcon(type: item.dice, size: 52),
        SizedBox(
          width: 48,
          child: controller.canIncrease(statId)
              ? EyuunWidgets.circularFloatingActionButton(
                  icon: Icons.keyboard_arrow_right_rounded,
                  radius: 38.0,
                  tooltip: textService.getText('uitext_attribute_increase'),
                  onPressed: () {
                    setState(() => controller.increase(statId));
                  },
                )
              : null,
        ),
        EyuunWidgets.spacerHorizontal(),
        Expanded(child: Text(textService.getTextFromEntity(item.stat))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();
    final controller = widget.controller;
    final attributes = controller?.statValues ?? [];
    return Column(
      children: [
        Text(
          textService.getText('text_attributes'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 600,
            mainAxisExtent: 52,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: attributes.length,
          itemBuilder: (context, index) =>
              _buildStat(attributes[index], textService),
        ),
        if (controller?.hasPendingChanges == true) ...[
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              EyuunWidgets.floatingActionButton(
                icon: Icons.close,
                width: 100.0,
                height: 50.0,
                tooltip: textService.getText('uitext_attribute_cancel'),
                onPressed: () => setState(controller!.cancel),
              ),
              EyuunWidgets.floatingActionButton(
                icon: Icons.check,
                width: 100.0,
                height: 50.0,
                tooltip: textService.getText('uitext_attribute_accept'),
                onPressed: () {
                  try {
                    setState(controller!.accept);
                  } on StateError catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message)),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}

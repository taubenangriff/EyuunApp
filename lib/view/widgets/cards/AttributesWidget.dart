import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/view/popup/BuffDisplayPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attribute.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/controller/AttributesUpgradeController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:flutter/material.dart';

class AttributesWidget extends StatefulWidget {
  final AttributesUpgradeController? controller;
  final bool showUpgradeButtons;
  final VoidCallback? onChanged;

  const AttributesWidget({
    super.key,
    required this.controller,
    this.showUpgradeButtons = false,
    this.onChanged,
  });

  @override
  State<AttributesWidget> createState() => _AttributesWidgetState();
}

class _AttributesWidgetState extends State<AttributesWidget> {
  late final StreamSubscription<EntityUpdatedEvent> _updates;

  @override
  void initState() {
    super.initState();
    final character = locator<CharacterService>().character;
    _updates = locator<EventBus>().on<EntityUpdatedEvent>().listen((event) {
      if (event.entity == character &&
          (event.component is AttributesComponent ||
              event.component is UpgradableComponent)) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _updates.cancel();
    super.dispose();
  }

  Widget _buildStat(AttributeEntry item, TextService textService) {
    final controller = widget.controller!;
    final statId = item.stat.getTypeId();
    final buff = item.stat.get<AttributeComponent>()?.buffWhenUpgraded;
    final row = Row(
      children: [
        SizedBox(
          width: 48,
          child: widget.showUpgradeButtons && controller.canDecrease(statId)
              ? EyuunWidgets.circularFloatingActionButton(
                  icon: Icons.keyboard_arrow_left_rounded,
                  radius: 38.0,
                  tooltip: textService.getText('uitext_attribute_decrease'),
                  onPressed: () {
                    setState(() => controller.decrease(statId));
                    widget.onChanged?.call();
                  },
                )
              : null,
        ),
        DiceIcon(type: item.dice, size: 52),
        SizedBox(
          width: 48,
          child: widget.showUpgradeButtons && controller.canIncrease(statId)
              ? EyuunWidgets.circularFloatingActionButton(
                  icon: Icons.keyboard_arrow_right_rounded,
                  radius: 38.0,
                  tooltip: textService.getText('uitext_attribute_increase'),
                  onPressed: () {
                    setState(() => controller.increase(statId));
                    widget.onChanged?.call();
                  },
                )
              : null,
        ),
        EyuunWidgets.spacerHorizontal(),
        Expanded(
          child: InkWell(
            onTap: buff == null
                ? null
                : () => PopupUtil.popup(
                      context,
                      BuffDisplayPopup(
                        buff: buff,
                        title: textService.getTextFromEntity(item.stat),
                        subtitle: textService
                            .getText('uitext_attribute_bonus_per_upgrade'),
                      ),
                    ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(textService.getTextFromEntity(item.stat)),
            ),
          ),
        ),
      ],
    );
    return row;
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
      ],
    );
  }
}

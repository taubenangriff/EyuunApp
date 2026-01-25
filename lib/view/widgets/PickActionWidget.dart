import 'package:eyuunapp/view/popup/AcceptActionPopup.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/ActionCard.dart';

class PickActionWidget extends StatefulWidget {
  final List<Entity> Function() actionsBuilder;
  final void Function(Entity entity)? onPicked;

  const PickActionWidget({
    super.key,
    required this.actionsBuilder,
    this.onPicked,
  });

  @override
  State<PickActionWidget> createState() => _PickActionWidgetState();
}

class _PickActionWidgetState extends State<PickActionWidget> {
  final SkillLearnerComponent skillLearner = locator<CharacterService>().character.get<SkillLearnerComponent>() ?? SkillLearnerComponent();
  final AttributesComponent attributes = locator<CharacterService>().character.get<AttributesComponent>() ?? AttributesComponent();

  late List<Entity> actions = widget.actionsBuilder.call();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320, // 👈 card width
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 300,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return ActionCard(
          onTap: () async {
            final result = await PopupUtil.popup(
              context,
              AcceptActionPopup(buff: action),
            );
            if (result == null) return;

            widget.onPicked?.call(action);
            setState(() {
              actions = widget.actionsBuilder.call();
            });
          },
          skillLearner: skillLearner,
          attributes: attributes,
          actionEntity: action,
        );
      },
    );
  }
}

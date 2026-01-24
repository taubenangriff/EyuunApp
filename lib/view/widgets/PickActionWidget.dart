import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/ActionCard.dart';

class PickActionWidget extends StatelessWidget {
  final void Function(Entity entity)? onPicked;
  PickActionWidget({super.key, required this.actions, this.onPicked});

  final List<Entity> actions;

  // temporary placeholders – you said you’ll handle this later
  final skillLearner = SkillLearnerComponent();
  final attributes = AttributesComponent();

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
          onTap: () {
            onPicked?.call(action);
            PopupUtil.popup(
              context,
              Center(
                child: Text(
                  "Are you sure you want to skill $action?",
                  textAlign: TextAlign.center,
                ),
              ),
              maximumSize: const Size(600, 400),
            );
          },
          skillLearner: skillLearner,
          attributes: attributes,
          actionEntity: action,
        );
      },
    );
  }
}

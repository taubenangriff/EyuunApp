import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';

import '../popup/PopupUtil.dart';
import '../widgets/ActionCard.dart';

class PickActionWidget extends StatelessWidget {
  PickActionWidget({super.key, required this.actions});

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

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
  final List<Entity> Function() tricksBuilder;
  final List<Entity> Function() spellsBuilder;
  final void Function(Entity entity)? onTrickPicked;
  final void Function(Entity entity)? onSpellPicked;

  const PickActionWidget({
    super.key,
    required this.tricksBuilder,
    required this.spellsBuilder,
    this.onTrickPicked,
    this.onSpellPicked,
  });

  @override
  State<PickActionWidget> createState() => _PickActionWidgetState();
}

class _PickActionWidgetState extends State<PickActionWidget> {
  final SkillLearnerComponent skillLearner =
      locator<CharacterService>().character.get<SkillLearnerComponent>() ??
          SkillLearnerComponent();
  final AttributesComponent attributes =
      locator<CharacterService>().character.get<AttributesComponent>() ??
          AttributesComponent();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Spells'),
              Tab(text: 'Tricks'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ActionPicker(
                  actionsBuilder: widget.spellsBuilder,
                  onPicked: widget.onSpellPicked,
                  skillLearner: skillLearner,
                  attributes: attributes,
                ),
                _ActionPicker(
                  actionsBuilder: widget.tricksBuilder,
                  onPicked: widget.onTrickPicked,
                  skillLearner: skillLearner,
                  attributes: attributes,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPicker extends StatefulWidget {
  final List<Entity> Function() actionsBuilder;
  final void Function(Entity entity)? onPicked;
  final SkillLearnerComponent skillLearner;
  final AttributesComponent attributes;

  const _ActionPicker({
    required this.actionsBuilder,
    required this.onPicked,
    required this.skillLearner,
    required this.attributes,
  });

  @override
  State<_ActionPicker> createState() => _ActionPickerState();
}

class _ActionPickerState extends State<_ActionPicker> {
  late List<Entity> actions = widget.actionsBuilder();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
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

            setState(() {
              actions = widget.actionsBuilder();
            });
            widget.onPicked?.call(action);
          },
          skillLearner: widget.skillLearner,
          attributes: widget.attributes,
          actionEntity: action,
        );
      },
    );
  }
}

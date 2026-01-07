import 'package:EyuunApp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class ActionsWidget extends StatefulWidget {
  final ActionUserComponent actionUser;
  final AttributesComponent attributes;

  const ActionsWidget({super.key, required this.actionUser, required this.attributes});

  @override
  State<ActionsWidget> createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends State<ActionsWidget> {
  var filtrableActionTimes = [ActionTime.Action, ActionTime.Reaction, ActionTime.ActionAndReaction, ActionTime.Attack, ActionTime.Defend, ActionTime.Time];
  var filteredActionTimes = [];

  final _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {

    var actions = widget.actionUser.getActions();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var actionType in filtrableActionTimes)
            FilterChip(
              label: Text(_textService.getText(actionType.getTextKey())),
              showCheckmark: true,
              shape: StadiumBorder(side: BorderSide()),
              backgroundColor: Colors.transparent,
              onSelected: (bool value) {
                setState(() {
                  if(value){
                    filteredActionTimes.add(actionType);
                    return;
                  }
                  filteredActionTimes.remove(actionType);
                });
              },
              selected: filteredActionTimes.contains(actionType),
            ),
        ],
      ),

      GridView.builder(
        padding: const EdgeInsets.all(12),
        shrinkWrap: true, // fits inside other scrollables
        physics:
        const NeverScrollableScrollPhysics(), // avoid nested scrolling
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300, // 👈 desired item width
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1, // tweak if needed
        ),
        itemCount: actions.length,
        itemBuilder: (BuildContext context, int index) {
          var entity = actions[index];
          return buildCard(context, entity);
        },
      )
    ]);
  }

  Widget buildCard(BuildContext context, Entity entity) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🏷 Title
            Text(
              _textService.getTextFromEntity(entity),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // 📖 Description
            Text(
              "Lorem Ipsum fuck fuck fuck",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 16),

            // 🎲 Skill check widget
            if(entity.has<SkillcheckComponent>())
              SkillCheckWidget(skillcheck: entity.get<SkillcheckComponent>()!, attributes: widget.attributes, useWrap: true),
          ],
        ),
      ),
    );
  }
}

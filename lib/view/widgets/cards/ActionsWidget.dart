import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/ActionCard.dart';

class ActionsWidget extends StatefulWidget {
  final ActionUserComponent actionUser;
  final AttributesComponent attributes;
  final SkillLearnerComponent skillLearner;

  const ActionsWidget(
      {super.key,
      required this.actionUser,
      required this.attributes,
      required this.skillLearner});

  @override
  State<ActionsWidget> createState() => _ActionsWidgetState();
}

class Filter {
  String name;
  List<ActionTime> filters;
  Filter(this.name, this.filters);
}

class _ActionsWidgetState extends State<ActionsWidget> {
  var filters = [
    Filter('uitext_actiontime_all', [
      ActionTime.None,
      ActionTime.Action,
      ActionTime.Reaction,
      ActionTime.Attack,
      ActionTime.Defend,
      ActionTime.Time,
      ActionTime.ActionAndReaction
    ]),
    Filter('uitext_actiontime_action', [ActionTime.Action]),
    Filter('uitext_actiontime_reaction', [ActionTime.Reaction]),
    Filter('uitext_actiontime_round', [ActionTime.ActionAndReaction]),
    Filter('uitext_actiontime_attack', [ActionTime.Attack]),
    Filter('uitext_actiontime_defend', [ActionTime.Defend]),
    Filter('uitext_actiontime_time', [ActionTime.Time]),
    Filter('uitext_actiontime_none', [ActionTime.None]),
  ];

  var selectedChoiceIndex = 0;

  final _textService = locator<TextService>();

  @override
  void initState() {
    super.initState();

    var preexistingFilterData = widget.actionUser.preferredActionTimes;
    var selectedFilterIndex = filters.indexWhere(
        (e) => e.filters.every((y) => preexistingFilterData.contains(y)));
    if (selectedFilterIndex >= 0) {
      selectedChoiceIndex = selectedFilterIndex;
      widget.actionUser.preferredActionTimes =
          filters[selectedFilterIndex].filters;
    } else {
      widget.actionUser.preferredActionTimes = filters[0].filters;
    }
  }

  @override
  Widget build(BuildContext context) {
    var actions = widget.actionUser.getActionsWithSource();

    actions = actions.where((e) {
      var actionDescriptor = e.action;
      var actionTime = actionDescriptor.get<ActionComponent>()?.actionTime;
      if (actionTime == null) {
        return false;
      }
      return widget.actionUser.preferredActionTimes.contains(actionTime);
    }).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var (index, filter) in filters.indexed)
            ChoiceChip(
              label: Text(_textService.getText(filter.name)),
              showCheckmark: true,
              shape: StadiumBorder(side: BorderSide()),
              backgroundColor: Colors.transparent,
              onSelected: (bool value) {
                setState(() {
                  if (value) {
                    selectedChoiceIndex = index;
                    widget.actionUser.preferredActionTimes = filter.filters;
                  }
                });
              },
              selected: selectedChoiceIndex == index,
            ),
        ],
      ),
      GridView.builder(
        padding: const EdgeInsets.all(12),
        shrinkWrap: true, // fits inside other scrollables
        physics: const NeverScrollableScrollPhysics(), // avoid nested scrolling
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 320, // 👈 desired item width
          mainAxisExtent: 270,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: actions.length,
        itemBuilder: (BuildContext context, int index) {
          var actionLink = actions[index];
          return ActionCard(
              onTap: () {
                PopupUtil.popup(
                    context,
                    const Center(
                        child: Text(
                            "Popup showing the action in full and a button to cast it.")),
                    maximumSize: Size(600, 400));
              },
              skillLearner: widget.skillLearner,
              attributes: widget.attributes,
              actionEntity: actionLink.action,
              sourceEntity:
                  actionLink.hasExternalSource() ? actionLink.source : null);
        },
      )
    ]);
  }
}

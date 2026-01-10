import 'package:EyuunApp/view/popup/PopupUtil.dart';
import 'package:EyuunApp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/enums/ActionTime.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

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

class Filter{
  String name;
  List<ActionTime> filters;
  Filter(this.name, this.filters);
}

class _ActionsWidgetState extends State<ActionsWidget> {
  var filters = [
    Filter('uitext_actiontime_all', [ActionTime.None, ActionTime.Action, ActionTime.Reaction, ActionTime.Attack, ActionTime.Defend, ActionTime.Time, ActionTime.ActionAndReaction]),
    Filter('uitext_actiontime_action', [ActionTime.Action]),
    Filter('uitext_actiontime_reaction', [ActionTime.Reaction]),
    Filter('uitext_actiontime_round', [ActionTime.ActionAndReaction]),
    Filter('uitext_actiontime_attack', [ActionTime.Attack]),
    Filter('uitext_actiontime_defend', [ActionTime.Defend]),
    Filter('uitext_actiontime_time', [ActionTime.Time]),
    Filter('uitext_actiontime_none', [ActionTime.None]),
  ];

  late var filteredActionTimes = filters[0].filters;

  var selectedChoiceIndex = 0;

  final _textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    var actions = widget.actionUser.getStaticActions();

    actions = actions.where((e) {
      var actionDescriptor = e.action;
      var actionTime = actionDescriptor.get<ActionComponent>()?.actionTime;
      if (actionTime == null) {
        return false;
      }
      return filteredActionTimes.contains(actionTime);
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
                    filteredActionTimes = filter.filters;
                  }
                  filteredActionTimes = filter.filters;
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
          mainAxisExtent: 250,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: actions.length,
        itemBuilder: (BuildContext context, int index) {
          var actionLink = actions[index];
          return buildCard(context, actionLink);
        },
      )
    ]);
  }

  Widget buildCard(BuildContext context, ActionLink actionLink) {
    var entity = actionLink.action;
    var hasWeapon = entity.has<WeaponComponent>();

    SkillcheckController skillcheckController =
        SkillcheckController(widget.skillLearner, widget.attributes);

    return GestureDetector(
      onTap: () {
        PopupUtil.popup(context, const Center(child: Text("Popup showing the action in full and a button to cast it.")), maximumSize: Size(600, 400));
      },
    child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.pin_drop),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                _textService.getText(
                    entity.get<ActionComponent>()!.actionTime.getTextKey()),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 44),
                // 🏷 Title
                Text(
                  _textService.getTextFromEntity(entity) + (actionLink.hasExternalSource() ? " (${_textService.getTextFromEntity(actionLink.source)})" : ""),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // 📖 Description
                Text(
                  _textService.getActionDescriptionFromEntity(entity),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 16),
              ],
            ),
            // 🎲 Skill check widget
            if (entity.has<SkillcheckComponent>())
              Positioned(
                  bottom: 4,
                  child: Center(
                      child: SkillCheckWidget(
                          skillcheck: entity.get<SkillcheckComponent>()!,
                          attributes: widget.attributes,
                          useWrap: false,
                          spacing: 0,
                          iconSize: 32))),
            if (hasWeapon)
              Positioned(
                child: Text(
                    "Skill: ${skillcheckController.getWeaponSkill(entity)}"),
                top: 4,
                right: 4,
              )
          ]),
        )));  }
}

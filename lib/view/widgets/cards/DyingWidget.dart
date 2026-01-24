import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/widgets/SkillCheckWidget.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/components/feature/DeathFeature.dart';
import 'package:eyuuncore/controller/SkillcheckController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:eyuuncore/controller/DyingStateController.dart';

class DyingWidget extends StatefulWidget {
  DyingStateController controller;
  DeathFeatureComponent deathFeature = locator<DeathFeatureComponent>();
  final attributes =
      locator<CharacterService>().character.get<AttributesComponent>();
  DyingWidget({super.key, required this.controller});

  @override
  State<DyingWidget> createState() => _DyingWidgetState();
}

class _DyingWidgetState extends State<DyingWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillcheck =
        widget.deathFeature.deathSkillcheck?.get<SkillcheckComponent>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
            alignment: Alignment.center,
            child: Text(
              '!Dying',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        if(widget.controller.isDying()) ...{
          EyuunWidgets.spacerVertical(),
          Center(child: Text(locator<TextService>().getText('uitext_indyingstate'), style: theme.textTheme.bodyMedium))
        },
        if(widget.controller.isStabilized()) ...{
          EyuunWidgets.spacerVertical(),
          Center(child: Text(locator<TextService>().getText('uitext_stabilized'), style: theme.textTheme.bodyMedium))
        },
        EyuunWidgets.spacerVertical(),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          spacing: 8,
          children: [
            Text('Death Threshold: ${widget.controller.getCurrentThreshold()}',
                style: theme.textTheme.bodyLarge),
            EyuunWidgets.spacerHorizontal(),
            if (skillcheck != null && widget.attributes != null)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Against: ', style: theme.textTheme.bodyLarge),
                SkillCheckWidget(
                    skillcheck: skillcheck,
                    attributes: widget.attributes!,
                    iconSize: 52)
              ]),
            if(widget.controller.isDying()) ... {
              EyuunWidgets.spacerHorizontal(),
              EyuunWidgets.floatingActionButton(
                  text: '!Get stabilized',
                  width: 150,
                  height: 50,
                  onPressed: () {
                    setState(() {
                      widget.controller.stabilize();
                    });
                  }),
            },
            if(widget.controller.isDying()) ... {
              EyuunWidgets.spacerHorizontal(),
              EyuunWidgets.floatingActionButton(
                  text: '!Pass Deathsave',
                  width: 150,
                  height: 50,
                  onPressed: () {
                    setState(() {
                      widget.controller.increaseDyingCheck();
                    });
                  }),
            },
            if(widget.controller.isDying()) ... {
              EyuunWidgets.spacerHorizontal(),
              EyuunWidgets.floatingActionButton(
                  icon: Icons.directions_transit_filled_outlined,
                  text: 'Sterben',
                  width: 150,
                  height: 50,
                  onPressed: () {
                    setState(() {
                      PopupUtil.popup(context,
                          Center(child: Text(
                              "Are you sure this character is dead?")))
                          .then((value) {
                        if (value == null) return;
                        //TODO implement proper dialog here
                        widget.controller.die();
                      });
                    });
                  }),
            },
            if(widget.controller.isStabilized()) ... {
              EyuunWidgets.spacerHorizontal(),
              EyuunWidgets.floatingActionButton(
                  text: 'Take Damage',
                  width: 150,
                  height: 50,
                  onPressed: () {
                    setState(() {
                      widget.controller.startDying();
                    });
                  }),
            },
          ],
        )
      ],
    );
  }
}

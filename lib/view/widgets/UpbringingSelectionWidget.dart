import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/controller/PickUpbringingController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../popup/UpbringingPickerPopup.dart';
import 'SelectionCard.dart';
import 'eyuun/EyuunWidgets.dart';

class UpbringingSelectionWidget extends StatefulWidget {
  final CharacterBaseComponent characterBaseComponent;
  final PickUpbringingController upbringingController;

  const UpbringingSelectionWidget(
      {super.key,
      required this.characterBaseComponent,
      required this.upbringingController});

  @override
  State<UpbringingSelectionWidget> createState() =>
      _UpbringingSelectionWidgetState();
}

class _UpbringingSelectionWidgetState extends State<UpbringingSelectionWidget> {
  final TextService textService = locator<TextService>();
  late final PickUpbringingController upbringingController =
      widget.upbringingController;

  @override
  Widget build(BuildContext context) {
    final character = widget.characterBaseComponent;

    double cardHeight = 130;

    var childhood = character.childhood;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: cardHeight),
          child: SelectionCard(
            title: textService.getText('uitext_upbringing') +
                (upbringingController.hasUpbringing() != null
                    ? textService.getTextFromEntity(
                        upbringingController.selectedUpbringing)
                    : ""),
            buff: upbringingController.selectedUpbringing,
            showBuff: !upbringingController.pickedBoth(),
            fallbackText: textService.getText('uitext_pick_upbringing'),
            onTap: () => _openPicker(
              context,
              upbringingController.getCurrentlySelectableUpbringings(),
              (buff) {
                setState(() {
                  upbringingController.pickUpbringing(buff);
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: cardHeight),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              SelectionCard(
                title: textService
                        .getText('uitext_secondary_upbringing_select') +
                    (upbringingController.hasAdditionalUpbringing()
                        ? textService.getTextFromEntity(
                            upbringingController.selectedAdditionalUpbringing)
                        : ""),
                buff: upbringingController.selectedAdditionalUpbringing,
                showBuff: !upbringingController.pickedBoth(),
                fallbackText:
                    textService.getText('uitext_pick_secondUpbringing'),
                onTap: () => _openPicker(
                  context,
                  upbringingController
                      .getCurrentlySelectableAdditionalUpbringings(),
                  (buff) {
                    setState(() {
                      upbringingController.pickAdditionalUpbringing(buff);
                    });
                  },
                ),
              ),
              if (upbringingController.hasAdditionalUpbringing())
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          upbringingController.clearAdditional();
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: cardHeight),
          child: SelectionCard(
            title: textService.getText('uitext_childhood') +
                (childhood != null
                    ? textService.getTextFromEntity(childhood)
                    : ""),
            buff: childhood,
            fallbackText: textService.getText('uitext_pick_childhood'),
            onTap: () => _openPicker(
              context,
              locator<CharacterTablesFeatureComponent>().childhoods,
              (buff) {
                setState(() {
                  character.childhood = buff;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (upbringingController.pickedBoth()) ...{
          Divider(),
          const SizedBox(height: 16),
          Column(children: [
            Text(
              locator<TextService>()
                  .getText('uitext_selectupbringingbuff_header'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            EyuunWidgets.spacerVertical(),
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Center(
                    child: Text(
                  locator<TextService>()
                      .getText('uitext_selectupbringingbuff_explainer'),
                  textAlign: TextAlign.center,
                ))),
            EyuunWidgets.spacerVertical(),
            SegmentedButton<Entity?>(
              multiSelectionEnabled: false,
              emptySelectionAllowed: true,
              segments: upbringingController
                  .getPossibleUpbringingBuffsFromPreselection()
                  .map((buff) => ButtonSegment(
                      value: buff,
                      label:
                          Text(locator<TextService>().getTextFromEntity(buff))))
                  .toList(),
              selected: upbringingController.hasAnyUpbringing()
                  ? {upbringingController.buffProvidingUpbringing}
                  : {},
              onSelectionChanged: (newSelection) {
                setState(() {
                  upbringingController
                      .setBuffProvidingUpbringing(newSelection.first!);
                });
              },
            ),
            EyuunWidgets.spacerVertical(),
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700, minHeight: 200),
                child: BuffDisplay(
                    buff: upbringingController.buffProvidingUpbringing))
          ])
        }
      ],
    );
  }

  void _openPicker(
    BuildContext context,
    List<Entity> buffs,
    void Function(Entity) selectedBuffCallback,
  ) {
    PopupUtil.popup(
      context,
      UpbringingPickerPopup(
        possibleBuffs: buffs,
        selectedBuffCallback: selectedBuffCallback,
      ),
      maximumSize: const Size(1100, 800),
    );
  }
}

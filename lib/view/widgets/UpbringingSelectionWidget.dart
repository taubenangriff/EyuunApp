import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:flutter/material.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:oxygen/oxygen.dart';

import '../popup/UpbringingPickerPopup.dart';
import 'SelectionCard.dart';

class UpbringingSelectionWidget extends StatefulWidget {
  final CharacterBaseComponent characterBaseComponent;

  const UpbringingSelectionWidget({
    super.key,
    required this.characterBaseComponent,
  });

  @override
  State<UpbringingSelectionWidget> createState() =>
      _UpbringingSelectionWidgetState();
}

class _UpbringingSelectionWidgetState extends State<UpbringingSelectionWidget> {
  final TextService textService = locator<TextService>();

  @override
  Widget build(BuildContext context) {
    final character = widget.characterBaseComponent;

    double cardHeight = 140;

    var upbringing = character.upbringing.getEntity();
    var secondUpbringing = character.secondUpbringing?.getEntity();
    var childhood = character.childhood.getEntity();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: cardHeight),
          child: SelectionCard(
            title: textService.getText('uitext_upbringing') + (upbringing != null ? textService.getTextFromEntity(upbringing) : ""),
            buff: upbringing,
            fallbackText: textService.getText('uitext_pick_upbringing'),
            onTap: () => _openPicker(
              context,
              locator<CharacterTablesFeatureComponent>().upbringings,
              (buff) {
                setState(() {
                  character.upbringing = AssetLink.fromEntity(buff);
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: cardHeight),
          child: SelectionCard(
            title: textService.getText('uitext_secondary_upbringing_select') + (secondUpbringing != null ? textService.getTextFromEntity(secondUpbringing) : ""),
            buff: secondUpbringing,
            fallbackText: textService.getText('uitext_pick_secondUpbringing'),
            onTap: () => _openPicker(
              context,
              locator<CharacterTablesFeatureComponent>().secondaryUpbringings,
              (buff) {
                setState(() {
                  character.secondUpbringing = AssetLink.fromEntity(buff);
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: cardHeight),
          child: SelectionCard(
            title: textService.getText('uitext_childhood') + (childhood != null ? textService.getTextFromEntity(childhood) : ""),
            buff: childhood,
            fallbackText: textService.getText('uitext_pick_childhood'),
            onTap: () => _openPicker(
              context,
              locator<CharacterTablesFeatureComponent>().childhoods,
              (buff) {
                setState(() {
                  character.childhood = AssetLink.fromEntity(buff);
                });
              },
            ),
          ),
        ),
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

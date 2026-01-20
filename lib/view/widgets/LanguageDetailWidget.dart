import 'package:eyuuncore/components/Language.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class LanguageDetailWidget extends StatelessWidget {
  final Entity languageEntity;

  const LanguageDetailWidget({
    super.key,
    required this.languageEntity,
  });

  @override
  Widget build(BuildContext context) {
    final languageComp = languageEntity.get<LanguageComponent>();

    if (languageComp == null) {
      return const SizedBox.shrink();
    }

    var textService = locator<TextService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (languageComp.written)
          Row(
            children: [
              const Icon(
                Icons.text_format,
                size: 28,
              ),
              const SizedBox(width: 4),
              Text(
                textService.getText("uitext_written_language"),
              ),
            ],
          ),
        if (languageComp.spoken) EyuunWidgets.spacerVertical(),
        if (languageComp.spoken)
          Row(
            children: [
              const Icon(
                Icons.speaker_notes_outlined,
                size: 28,
              ),
              const SizedBox(width: 4),
              Text(
                textService.getText("uitext_spoken_language"),
              ),
            ],
          ),
        if (languageComp.alternativeCommunicationStyle)
          EyuunWidgets.spacerVertical(),
        if (languageComp.alternativeCommunicationStyle)
          Row(
            children: [
              const Icon(
                Icons.sign_language,
                size: 28,
              ),
              const SizedBox(width: 4),
              Flexible(
                  child: Text(
                textService.getText("uitext_altcom_language"),
              )),
            ],
          ),
        EyuunWidgets.spacerVertical(),

        // Fluff text
        Text(
          locator<TextService>().getFluffFromEntity(languageEntity),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}

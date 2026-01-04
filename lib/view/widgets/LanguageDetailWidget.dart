import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

import '../../components/Language.dart';
import '../../core/registerServices.dart';
import '../../core/services/TextService.dart';

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
        if (languageComp.spoken) const SizedBox(height: 12),
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
          const SizedBox(height: 12),
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
        const SizedBox(height: 12),

        // Fluff text
        Text(
          locator<TextService>().getFluffFromEntity(languageEntity),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (languageComp.written)
          const Row(
            children: [
              Icon(
                Icons.text_format,
                size: 28,
              ),
              SizedBox(width: 4),
              Text(
                "Written",
              ),
            ],
          ),
        if (languageComp.spoken) const SizedBox(height: 12),
        if (languageComp.spoken)
          const Row(
            children: [
              Icon(
                Icons.speaker_notes_outlined,
                size: 28,
              ),
              SizedBox(width: 4),
              Text(
                "Spoken",
              ),
            ],
          ),
        if (languageComp.alternativeCommunicationStyle)
          const SizedBox(height: 12),
        if (languageComp.alternativeCommunicationStyle)
          const Row(
            children: [
              Icon(
                Icons.sign_language,
                size: 28,
              ),
              SizedBox(width: 4),
              Text("Alternative Communication"),
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

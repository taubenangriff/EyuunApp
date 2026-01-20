import 'package:eyuuncore/controller/LanguagesController.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/LanguageDetailWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';

class SelectLanguagePopup extends StatefulWidget {
  final LanguagesController languagesController;
  final VoidCallback? onAccept;

  SelectLanguagePopup(
      {super.key, required this.languagesController, this.onAccept});

  @override
  State<SelectLanguagePopup> createState() => _SelectLanguagePopupState();
}

class _SelectLanguagePopupState extends State<SelectLanguagePopup> {
  Entity? selectedLanguage;

  var textService = locator<TextService>();

  bool spendLangPotential = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            textService.getText("uitext_picklanguage"),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // 🌐 Grid of languages
          Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300, // 👈 desired item width
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2, // tweak if needed
                ),
                itemCount: widget.languagesController.learnableLanguages.length,
                itemBuilder: (context, index) {
                  final language =
                  widget.languagesController.learnableLanguages[index];
                  final isSelected = selectedLanguage == language;

                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedLanguage = language;
                        });
                      },
                      child: Container(
                        decoration: EyuunDecoration(
                            paint: isSelected
                                ? Brushes.goldSparkling()
                                : Brushes.silverSparkling(),
                            cornerSize: isSelected ? 16 : 12,
                            paintInnerLine: false,
                            fillCorners: isSelected),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                locator<TextService>()
                                    .getTextFromEntity(language),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              LanguageDetailWidget(languageEntity: language)
                            ],
                          ),
                        ),
                      ));
                },
              )),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "${textService.getText("uitext_spendlangpotential")} ${widget.languagesController.getRemainingPotential()}"),
              const SizedBox(width: 12),
              Switch(
                value: spendLangPotential,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    spendLangPotential = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
              child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: EyuunDecoration(
                      paint: Brushes.goldSparkling(), cornerSize: 12),
                  child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: selectedLanguage != null
                            ? () {
                          setState(() {
                            widget.languagesController.learnLanguage(
                                selectedLanguage!,
                                throughProject: !spendLangPotential);

                            Navigator.of(context).pop();
                            setState(() {
                              widget.onAccept?.call();
                            });
                          });
                        }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: selectedLanguage != null
                                ? [
                              Icon(Icons.add),
                              Text(
                                  '${textService.getText('uitext_addlang')}')
                            ]
                                : [
                              Text(textService
                                  .getText('uitext_addlang_02'))
                            ],
                          ),
                        ),
                      )))),
        ],
      ),
    );
  }
}

import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';
import '../widgets/eyuun/EyuunWidgets.dart';
import 'PickActionPopup.dart';

class DecideActionCategoryPopup extends StatelessWidget {
  const DecideActionCategoryPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: EyuunDecoration(
          paint: Brushes.silverSparkling(),
          cornerSize: 12,
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EyuunWidgets.spacerVertical(),
                  Center(
                      child: Text(
                    locator<TextService>().getText('uitext_pickselectlist'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  EyuunWidgets.spacerVertical(),
                  Divider(),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.floatingActionButton(
                      height: 60,
                      text:
                          locator<TextService>().getText('uitext_picknewtrick'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        PopupUtil.largePopup(
                            context,
                            PickActionPopup(
                                actions:
                                    locator<CharacterTablesFeatureComponent>()
                                        .tricks,
                                headerKey: 'uitext_picknewtrick'),
                            header: locator<TextService>()
                                .getText('uitext_picknewtrick'),
                            background:
                                AssetImage('data/base/ui/bg/background.jpg'));
                      }),
                  EyuunWidgets.spacerVertical(),
                  EyuunWidgets.floatingActionButton(
                      height: 60,
                      text:
                          locator<TextService>().getText('uitext_picknewspell'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        PopupUtil.largePopup(
                            context,
                            PickActionPopup(
                                actions:
                                    locator<CharacterTablesFeatureComponent>()
                                        .spells,
                                headerKey: 'uitext_picknewspell'),
                            header: locator<TextService>()
                                .getText('uitext_picknewspell'),
                            background:
                                AssetImage('data/base/ui/bg/background.jpg'));
                      })
                ])));
  }
}

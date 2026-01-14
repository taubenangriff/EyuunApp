import 'dart:math';

import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuunapp/main.dart';
import 'package:eyuunapp/view/popup/PathPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../enum/PathTypeColorExtension.dart';
import '../popup/PickPathPopup.dart';
import '../widgets/eyuun/Brushes.dart';

class BuffDisplayPopup extends StatelessWidget {
  final Entity? buff;

  const BuffDisplayPopup({
    required this.buff,
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return DecoratedBox(
      decoration: EyuunDecoration(paint: Brushes.silverSparkling(), cornerSize: 12),
      child:
      buff != null ? Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 30, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                locator<TextService>()
                    .getTextFromEntity(buff!),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 16),
            BuffDisplay(buff: buff)
          ],
        )): const SizedBox(width:300, height:200));
  }
}
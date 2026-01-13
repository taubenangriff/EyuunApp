import 'package:eyuuncore/controller/PathController.dart';
import 'package:flutter/material.dart';

import '../widgets/PickNewPathWidget.dart';
import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';

class PickPathPopup extends StatelessWidget {
  final PathController pathController;
  final void Function(String pathId)? onPathPicked;

  const PickPathPopup({
    super.key,
    required this.pathController,
    this.onPathPicked,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: EyuunDecoration(
        paint: Brushes.silverSparkling(),
        cornerSize: 12,
      ),
      child: PickNewPathWidget(
        pathController: pathController,
        onPathPicked: onPathPicked,
      ),
    );
  }
}

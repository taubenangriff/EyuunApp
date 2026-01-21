import 'package:eyuuncore/controller/PathController.dart';
import 'package:flutter/material.dart';

import 'package:eyuunapp/view/widgets/PickNewPathWidget.dart';
import 'package:oxygen/oxygen.dart';

class PickPathPopup extends StatelessWidget {
  final PathController pathController;
  final void Function(Entity path)? onPathPicked;

  const PickPathPopup({
    super.key,
    required this.pathController,
    this.onPathPicked,
  });

  @override
  Widget build(BuildContext context) {
    return PickNewPathWidget(
      pathController: pathController,
      onPathPicked: onPathPicked,
    );
  }
}

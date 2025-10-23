import 'package:flutter/material.dart';

class PopupUtil {

  static const Size defaultSize = Size(300, 500);

  static Future<E?> popup<E>(
      BuildContext context, Widget content, {Size maximumSize = defaultSize}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              insetPadding: const EdgeInsets.all(24),
              child: Stack(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: maximumSize.height,
                        maxWidth: maximumSize.width), // max popup height
                    child: content,
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ));
        });
  }
}

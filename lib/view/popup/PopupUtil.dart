import 'package:flutter/material.dart';

import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';

class PopupUtil {
  static const Size defaultSize = Size(300, 500);
  static const Size largeDefaultSize = Size(1100, 900);

  static Future<E?> _sizedPopup<E>(
      BuildContext context, Widget content, Size maximumSize) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: DecoratedBox(
                  decoration: EyuunDecoration(
                      paint: Brushes.silverSparkling(), cornerSize: 12),
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
                  )));
        });
  }

  static Future<E?> _fullscreenPopup<E>(
      BuildContext context, Widget content, Size maximumSize) async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text("Eyuun App"),
            ),
            body: Stack(
              children: [
                Center(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: maximumSize.height,
                      maxWidth: maximumSize.width), // max popup height
                  child: content,
                ))
              ],
            )),
      ),
    );
  }

  static Future<E?> largePopup<E>(BuildContext context, Widget content,
      {Size maximumSize = largeDefaultSize}) async {
    return _fullscreenPopup(context, content, maximumSize);
  }

  static Future<E?> popup<E>(BuildContext context, Widget content,
      {Size maximumSize = defaultSize}) async {
    return _sizedPopup(context, content, maximumSize);
  }
}

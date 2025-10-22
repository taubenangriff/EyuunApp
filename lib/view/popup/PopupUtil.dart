import 'package:flutter/material.dart';

class PopupUtil {
  static Future<E?> popup<E>(BuildContext context, Widget content,
      {List<Widget> actions = const [],
      MainAxisAlignment? actionAlignment,
      bool wide = false}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(24),
            child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 500, maxWidth: 300), // max popup height
                  child: content,
                ),
                  ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close'))
              ],)
          );
        });
  }
}

import 'package:fluent_bundle/fluent_bundle.dart';
import 'package:flutter/services.dart';

class TextRepository {
  FluentBundle? _bundle;

  String getText(String key) {
    if (_bundle?.hasMessage(key) ?? false) {
      return _bundle!.formatMessage(key);
    }

    return "¿" + key.toString() + "?";
  }

  Future<void> reloadTexts(String textFile) async {
    final source = await rootBundle.loadString(textFile);
    final locale = textFile
        .split('/')
        .last
        .split('.')
        .first
        .replaceAll('_', '-');
    final bundle = FluentBundle(locale, useIsolating: false);
    final result = bundle.addResource(source);
    if (result.hasErrors) {
      throw FormatException('Invalid Fluent resource: $textFile');
    }
    _bundle = bundle;
  }
}

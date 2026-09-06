import 'dart:io';

import 'package:fluent_bundle/fluent_bundle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in ['de_de', 'en_us']) {
    test('$locale Fluent resource parses without errors', () async {
      final source = await File('../data/base/text/$locale.ftl').readAsString();
      final bundle = FluentBundle(
        locale.replaceAll('_', '-'),
        useIsolating: false,
      );

      final result = bundle.addResource(source);

      expect(result.hasErrors, isFalse);
      expect(bundle.hasMessage('baseSkill_Courage'), isTrue);
      if (locale == 'de_de') {
        expect(bundle.formatMessage('uitext_casted_scope'), 'Reichweite: {}');
      }
    });
  }
}

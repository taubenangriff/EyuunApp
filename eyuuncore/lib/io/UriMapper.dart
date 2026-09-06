import 'package:dart_mappable/dart_mappable.dart';

class UriMapper extends SimpleMapper<Uri> {
  const UriMapper();

  @override
  Uri decode(dynamic value) {
    return Uri.parse(value as String);
  }

  @override
  dynamic encode(Uri self) {
    return self.toString();
  }
}

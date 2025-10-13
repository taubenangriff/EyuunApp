
import 'package:reflectable/reflectable.dart';

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, ); // Request the capability to invoke methods.
}
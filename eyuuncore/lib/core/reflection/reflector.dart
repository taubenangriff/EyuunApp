import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/components/Language.dart';
import 'package:reflectable/reflectable.dart';

import 'reflector.reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, typingCapability, reflectedTypeCapability); // Request the capability to invoke methods.
}

const reflector = Reflector();


// for some GODFUCKING reason reflection needs entry points
void main() {

}
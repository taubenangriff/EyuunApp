import 'package:eyuuncore/core/registerComponentsExtension.dart';
import 'package:reflectable/reflectable.dart';

import '../repository/ComponentRepository.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, typingCapability, reflectedTypeCapability); // Request the capability to invoke methods.
}

const reflector = Reflector();

// for some GODFUCKING reason reflection needs entry points
void main() {
  ComponentRepository().registerComponents();
}
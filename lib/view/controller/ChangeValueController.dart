import 'dart:math';

class ChangeValueController {
  String name;
  int value;
  int maxLimit;
  int minLimit;

  ChangeValueController(this.value, {this.name = "", this.maxLimit = -1, this.minLimit = 0}) {
    if(maxLimit < 0) {
      maxLimit = value;
    }
    assert(minLimit <= value);
    assert(value <= maxLimit);
  }

  @override
  String toString() {
    return '$value / $maxLimit';
  }

  change(int changeBy) {
    value = max(minLimit, min(maxLimit, value+changeBy));
  }

  changeMax(int changeBy) {
    maxLimit = max(minLimit, maxLimit+changeBy);
    change(changeBy);
  }

  int maxLosable() {
    return value - minLimit;
  }

  int maxGainable() {
    return maxLimit - value;
  }

  toMax() {
    value = maxLimit;
  }

  toMin() {
    value = minLimit;
  }
}
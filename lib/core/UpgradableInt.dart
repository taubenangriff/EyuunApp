class UpgradableInt {
  int base = 0;
  int upgrade = 0;

  int get current => base + upgrade;

  UpgradableInt();

  void reset() => upgrade = 0;

  static UpgradableInt from(int value){
    var target = UpgradableInt();
    target.base = value;
    return target;
  }
}

extension UpgradableIntAssignExtension on int {
  UpgradableInt get upgradable => UpgradableInt.from(this);
}
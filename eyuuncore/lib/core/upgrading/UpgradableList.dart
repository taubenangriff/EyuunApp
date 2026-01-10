class UpgradableList<T> {
  List<T> baseList = [];
  List<T> upgradeList = [];

  List<T> get current => baseList + upgradeList;

  UpgradableList();

  void reset() => upgradeList = [];

  static UpgradableList<T> from<T>(List<T> value){
    var target = UpgradableList<T>();
    target.baseList = value;
    return target;
  }

  void add(T value){
    baseList.add(value);
  }

  void addUpgrade(T value){
    upgradeList.add(value);
  }
}

extension UpgradableIntAssignExtension<T> on List<T> {
  UpgradableList<T> get upgradable => UpgradableList.from<T>(this);
}
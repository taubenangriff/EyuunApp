import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/upgrading/UpgradableList.dart';

import 'upgrading/UpgradableInt.dart';

//Used for registering Upgrades in the WorldManager.

//TBase: Base Component
//TUpgrade: Upgrade Component
//getBase describes which property of the UpgradableInt type on the Base component is upgraded
//getUpgrade describes which property of the int type in the Update property is used for upgrading.
class UpgradeDescriptor {
  String typeIdBase;
  String typeIdUpgrade;
  UpgradableInt Function(EyuunComponent) getBase;
  int? Function(EyuunComponent) getUpgrade;

  UpgradeDescriptor(this.typeIdBase, this.typeIdUpgrade, this.getBase, this.getUpgrade);
}

class ListUpgradeDescriptor<T> {
  String typeIdBase;
  String typeIdUpgrade;
  UpgradableList<T> Function(EyuunComponent) getBase;
  List<T>? Function(EyuunComponent) getUpgrade;

  ListUpgradeDescriptor(this.typeIdBase, this.typeIdUpgrade, this.getBase, this.getUpgrade);
}
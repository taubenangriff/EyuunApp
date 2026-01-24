import 'package:eyuuncore/components/Cost.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/InventoryController.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';

import '../GetIt.dart';

class ShoppingController {
  final InventoryComponent _inventoryComponent;
  late InventoryController _inventoryController;
  late GameObjectService _gameObjectService;

  ShoppingController(this._inventoryComponent){
    _inventoryController = InventoryController(_inventoryComponent);
    _gameObjectService = locator<GameObjectService>();
  }

  void buyItem(String typeId){
    var staticAsset = _gameObjectService.getStatic(typeId);
    if(staticAsset == null){
      return;
    }

    var cost = staticAsset.get<CostComponent>();
    if(cost != null){
      if(_inventoryComponent.money < cost.money){
        return;
      }

      _inventoryComponent.money -= cost.money;

      //TODO deduct and check the other cost resources against the players inventory
    }

    var entityInstance = _gameObjectService.createInstance(typeId);

    if(entityInstance == null){
      return;
    }

    var slot = _inventoryController.getFirstFreeSlotIndex();
    _inventoryController.addObjectToSlot(entityInstance, slot);
  }
}
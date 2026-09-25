import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/components/Cost.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/InventoryController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/events/EntityCreatedEvent.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

import '../GetIt.dart';

class ShoppingController {
  final Entity buyingEntity;
  late InventoryComponent _inventoryComponent;
  late InventoryController _inventoryController;
  late GameObjectService _gameObjectService;

  ShoppingController(this.buyingEntity) {
    if (!buyingEntity.has<InventoryComponent>()) {
      throw Exception("BuyingEntity does not have an InventoryComponent");
    }

    _inventoryComponent = buyingEntity.get<InventoryComponent>()!;
    _inventoryController = InventoryController(_inventoryComponent);
    _gameObjectService = locator<GameObjectService>();
  }

  bool canBuyItem(String typeId) {
    var staticAsset = _gameObjectService.getStatic(typeId);
    if (staticAsset == null) {
      return false;
    }

    var cost = staticAsset.get<CostComponent>();
    if (cost != null) {
      if (_inventoryComponent.money < cost.money) {
        return false;
      }

      //TODO check the other cost resources against the players inventory
    }

    return true;
  }

  void buyItem(String typeId) {
    var staticAsset = _gameObjectService.getStatic(typeId);
    if (staticAsset == null) {
      return;
    }

    var cost = staticAsset.get<CostComponent>();
    if (cost != null) {
      if (_inventoryComponent.money < cost.money) {
        return;
      }

      _inventoryComponent.money -= cost.money;

      //TODO deduct and check the other cost resources against the players inventory
    }

    var entityInstance = _gameObjectService.createInstance(typeId);

    if (entityInstance == null) {
      return;
    }

    var slot = _inventoryController.getFirstFreeSlotIndex();
    _inventoryController.addObjectToSlot(entityInstance, slot);

    locator<EventBus>().fire(EntityCreatedEvent(entityInstance));
  }
}

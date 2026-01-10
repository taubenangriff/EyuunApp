import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/core/upgradeDescriptor.dart';
import 'package:oxygen/oxygen.dart';

import '../components/EyuunComponent.dart';

typedef FuncEyuunComponentAdder<T1 extends EyuunComponent<T2>, T2> = void Function(Entity entity);
typedef FuncEyuunComponentChecker<T1 extends EyuunComponent<T2>, T2> = bool Function(Entity entity);
typedef FuncEyuunComponentGetter<T1 extends EyuunComponent<T2>, T2> = T1? Function(Entity entity);

//The worldManager is keeping track of registered Components in order to allow dynamic access to properties.
//This is mainly used for IO, where you don't know the specifics of entites and need some abstraction.
class WorldManager{
  World world = World();
  World staticWorld = World();

  Map<String, FuncEyuunComponentAdder> entityAdder = {};
  Map<String, FuncEyuunComponentChecker> entityChecker = {};
  Map<String, FuncEyuunComponentGetter> entityGetter = {};
  Map<String, Type> components = {};

  List<UpgradeDescriptor> _updateRegistry = [];
  List<UpgradeDescriptor> get upgrades => _updateRegistry;

  void registerUpgrade (
      UpgradableInt Function(EyuunComponent) getBase,
      int? Function(EyuunComponent) getUpgrade,
      String baseTypeId,
      String upgradeTypeId) {
    _updateRegistry.add(UpgradeDescriptor(baseTypeId, upgradeTypeId, getBase, getUpgrade));
  }

  void registerComponent<T1 extends EyuunComponent<T2>, T2>(String propertyName, T1 Function() create){
    world.registerComponent(create);
    staticWorld.registerComponent(create);
    entityAdder[propertyName] = (Entity entity) => entity.add<T1, T2>();
    entityChecker[propertyName] = (Entity entity) => entity.has<T1>();
    entityGetter[propertyName] = (Entity entity) => entity.get<T1>();
    components[propertyName] = T1;
  }

  void addComponentToEntity(String componentName, Entity entity) {
    var func = entityAdder[componentName];
    if(func != null) {
      func(entity);
    }
  }

  bool entityHasComponent(String propertyName, Entity entity) {
    var check = entityChecker[propertyName];
    if(check != null) {
      return check(entity);
    }
    return false;
  }

  bool isValidComponentName(String componentName) => components.containsKey(componentName);

  EyuunComponent? getComponentFromEntity(String propertyName, Entity entity) {
    var getter = entityGetter[propertyName];
    if(getter != null) {
      return getter(entity);
    }
    return null;
  }

  void init()
  {
    world.init();
    staticWorld.init();
  }

  Iterable<String> allComponentTypes() => components.keys;
}
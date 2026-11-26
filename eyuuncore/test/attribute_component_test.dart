import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attribute.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/core/reflection/reflector.reflectable.dart';
import 'package:eyuuncore/core/registerComponentsExtension.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxygen/oxygen.dart';

class _GameObjectService implements GameObjectService {
  final Map<String, Entity> assets;

  _GameObjectService(this.assets);

  @override
  Entity? getStatic(String typeId) => assets[typeId];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('registers attribute for game entities and editor data', () {
    final worldManager = WorldManager()..registerComponents();
    final entity = worldManager.world.createEntity();

    expect(worldManager.isValidComponentName('attribute'), isTrue);
    worldManager.addComponentToEntity('attribute', entity);
    final component = entity.get<AttributeComponent>();
    expect(component, isNotNull);
    expect(worldManager.getComponentFromEntity('attribute', entity), component);
    component!.init();
    component.loadDynamicData({});
    expect(component.saveDynamicData(), isEmpty);

    final repository = ComponentRepository()..registerComponents();
    expect(repository.isComponent('attribute'), isTrue);
    final map = <String, dynamic>{
      'buffWhenUpgraded': {'id': 'upgrade_buff'},
    };
    final data = repository.fromMap('attribute', map);
    expect(data, isA<AttributeStatic>());
    expect(repository.toMap(data!), map);
    initializeReflectable();
    expect(
      reflector.reflect(data).invokeGetter('buffWhenUpgraded'),
      isA<AssetLink>(),
    );
  });

  test('loads and resets the referenced upgrade buff', () {
    final buff = World().createEntity();
    locator.registerSingleton<GameObjectService>(
      _GameObjectService({'upgrade_buff': buff}),
    );
    addTearDown(() => locator.unregister<GameObjectService>());

    final component = AttributeComponent()..init();
    expect(component.buffWhenUpgraded, isNull);
    component.loadStaticData({
      'buffWhenUpgraded': {'id': 'upgrade_buff'},
    });
    expect(component.buffWhenUpgraded, same(buff));
    component.reset();
    expect(component.buffWhenUpgraded, isNull);
    component.loadStaticData({});
    expect(component.buffWhenUpgraded, isNull);
  });
}

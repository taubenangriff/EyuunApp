import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:oxygen/oxygen.dart';

import '../../GetIt.dart';

class CharacterService {
  //character is read only!
  late Entity _character;
  Entity get character => _character;

  void changeCharacter(Entity character){
    _character = character;
  }

  void unload() {
    _character = locator<GameObjectService>().getStatic('character')!;
  }
}
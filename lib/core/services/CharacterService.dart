import 'package:oxygen/oxygen.dart';

class CharacterService {
  //character is read only!
  late Entity _character;
  Entity get character => _character;

  void changeCharacter(Entity character){
    _character = character;
  }
}
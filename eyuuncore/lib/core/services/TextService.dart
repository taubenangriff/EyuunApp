import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/text.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/repository/TextRepository.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:format/format.dart';
import 'package:oxygen/oxygen.dart';

import '../assetLink.dart';
import '../../GetIt.dart';

class TextService {
  late TextRepository _textRepository;
  late GameObjectService _gameObjectService;

  TextService() {
    _textRepository = locator<TextRepository>();
    _gameObjectService = locator<GameObjectService>();
  }

  String getTextFromEntity(Entity? entity, {final List<String> formatArgs = const []}) {
    if(entity == null){
      return "";
    }
    return getText(entity.getTextKey(), formatArgs: formatArgs);
  }

  String getActionDescriptionFromEntity(Entity? entity, {final List<String> formatArgs = const []}){
    if(entity == null){
      return "";
    }
    var key = entity.get<ActionComponent>()?.actionDescription;
    if(key == null){
      return "";
    }

    return getText(key, formatArgs: formatArgs);
  }

  String getFluffFromEntity(Entity? entity, {final List<String> formatArgs = const []}) {
    if(entity == null){
      return "";
    }
    var fluff = entity.getFluff();
    if(fluff == null){
      return "";
    }
    return getText(fluff, formatArgs: formatArgs);
  }

  String getShortFromEntity(Entity? entity, {final List<String> formatArgs = const []}) {
    if(entity == null){
      return "";
    }
    var short = entity.getShort();
    if(short == null){
      return "";
    }
    return getText(short, formatArgs: formatArgs);
  }

  String _getFormatted(String textKey, List<String> formatArgs) {
    var raw = _textRepository.getText(textKey);
    if(formatArgs.isEmpty) return raw;
    return format(raw, formatArgs);
  }

  String getText(String textLookup, {final List<String> formatArgs = const []}) => _getFormatted(getTextKey(textLookup), formatArgs);

  bool hasFluff(String typeId)
  {
    return _gameObjectService.getStatic(typeId)?.get<TextComponent>()?.fluff != null;
  }

  String getFluff(String typeId, {final List<String> formatArgs = const []})  => _getFormatted(getFluffKey(typeId), formatArgs);

  String getShort(String typeId, {final List<String> formatArgs = const []}) => _getFormatted(getShortKey(typeId), formatArgs);

  String getTextKey(String typeId) {
    var entity = _gameObjectService.getStatic(typeId);
    return entity?.getTextKey() ?? typeId;
  }

  String getFluffKey(String typeId) {
    var entity = _gameObjectService.getStatic(typeId);
    return entity?.getFluff() ?? typeId;
  }

  String getShortKey(String typeId) {
    var entity = _gameObjectService.getStatic(typeId);
    return entity?.getShort() ?? typeId;
  }
}
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/Upbringing.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/enums/PersonSize.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/registerServices.dart';

class PickUpbringingController {
  Entity? selectedUpbringing;
  Entity? selectedAdditionalUpbringing;
  Entity? _buffProvidingUpbringing;
  Entity? get buffProvidingUpbringing => _buffProvidingUpbringing;

  CharacterBaseComponent characterBase;

  PersonSize? selectedSize;

  PickUpbringingController(this.characterBase);

  List<PersonSize> getPossibleSizes() {
    var fromUpbringing = selectedUpbringing?.get<UpbringingComponent>()?.possibleSizes ?? [];
    var fromAdditional = selectedAdditionalUpbringing?.get<UpbringingComponent>()?.possibleSizes ?? [];
    var combined = fromAdditional + fromUpbringing;
    combined = combined.toSet().toList();
    return combined;
  }

  List<Entity> getCurrentlySelectableUpbringings() {
    return locator<CharacterTablesFeatureComponent>().upbringings.where((e) => e != selectedAdditionalUpbringing).toList();
  }

  List<Entity> getCurrentlySelectableAdditionalUpbringings() {
    return locator<CharacterTablesFeatureComponent>().secondaryUpbringings.where((e) => e != selectedUpbringing).toList();
  }

  clearAdditional(){
    if(_buffProvidingUpbringing == selectedAdditionalUpbringing){
      _buffProvidingUpbringing = null;
    }
    selectedAdditionalUpbringing = null;
  }

  pickUpbringing(Entity upbringing){
    selectedUpbringing = upbringing;
    _buffProvidingUpbringing ??= upbringing;
  }

  pickAdditionalUpbringing(Entity additionalUpbringing){
    selectedAdditionalUpbringing = additionalUpbringing;
    _buffProvidingUpbringing ??= additionalUpbringing;
  }

  bool pickedBoth() => selectedAdditionalUpbringing != null && selectedUpbringing != null;

  bool hasUpbringing() => selectedUpbringing != null;
  bool hasAdditionalUpbringing() => selectedAdditionalUpbringing != null;
  bool hasAnyUpbringing() => selectedUpbringing != null || selectedAdditionalUpbringing != null;

  List<Entity> getPossibleUpbringingBuffsFromPreselection() {
    var list = <Entity>[];
    if(selectedUpbringing != null){
      list.add(selectedUpbringing!);
    }
    if(selectedAdditionalUpbringing != null){
      list.add(selectedAdditionalUpbringing!);
    }
    return list;
  }

  setBuffProvidingUpbringing(Entity e){
    if(e != selectedUpbringing && e != selectedAdditionalUpbringing){
      throw ArgumentError("Buff providing upbringing must be either one of upbringing or additional upbringing!");
    }
    _buffProvidingUpbringing = e;
  }

  void lockInUpbringingBuffs(){
    if(buffProvidingUpbringing == null){
      throw StateError("Has not yet picked any upbringing");
    }
    if(selectedUpbringing == null){
      throw StateError("The main Upbringing has not yet been picked!");
    }
    characterBase.visualUpbringings.clear();

    characterBase.upbringing = buffProvidingUpbringing!;
    var visualUpbringing = buffProvidingUpbringing == selectedUpbringing ? selectedAdditionalUpbringing : selectedUpbringing;
    if(visualUpbringing != null){
      characterBase.visualUpbringings.add(visualUpbringing);
    }
  }
}
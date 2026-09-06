import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/view/widgets/CharacterPortraitPicker.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Nameable.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:oxygen/oxygen.dart';

class CharacterNameController extends ChangeNotifier {
  Entity entity;
  late NameableComponent? _nameable;
  late TextEditingController textController;

  CharacterNameController(this.entity) {
    _nameable = entity.get<NameableComponent>();

    textController = TextEditingController(text: _nameable?.name ?? "");
    if (_nameable == null) {
      return;
    }

    textController.addListener(() {
      _nameable!.name = textController.text;
    });
  }

  void submit() {
    if (_nameable == null) {
      return;
    }
    locator<EventBus>().fire(EntityUpdatedEvent(entity, _nameable!));
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }
}

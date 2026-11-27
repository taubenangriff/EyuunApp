import 'package:eyuunapp/view/widgets/cards/AttributesWidget.dart';
import 'package:eyuunapp/view/widgets/cards/HealthLevelupWidget.dart';
import 'package:eyuuncore/controller/HealthLevelupController.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/controller/AttributesController.dart';
import 'package:eyuuncore/controller/AttributesUpgradeController.dart';
import 'package:eyuuncore/controller/LevelController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

enum LevelupStage {
  attributes,
  health,
  complete,
}

class LevelupPage extends StatefulWidget {
  final LevelController levelController;

  const LevelupPage({
    required this.levelController,
    super.key,
  });

  @override
  State<LevelupPage> createState() => _LevelupPageState();
}

class _LevelupPageState extends State<LevelupPage> {
  late LevelupStage _currentStage;
  late final AttributesUpgradeController? _attributesController;
  late final bool _canUpgradeAttributes;
  late final HealthLevelupController _healthController;
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    final character = locator<CharacterService>().character;
    _healthController = HealthLevelupController(character);
    _attributesController = character.has<AttributesComponent>()
        ? AttributesUpgradeController(character)
        : null;

    _canUpgradeAttributes = _attributesController != null &&
        character.get<AttributesComponent>()!.statValues.any((entry) =>
            AttributesController(character.get<AttributesComponent>()!)
                .upgradesPossible(entry.stat.getTypeId()));

    _currentStage =
        _canUpgradeAttributes ? LevelupStage.attributes : LevelupStage.health;
  }

  /// The attribute stage is done once no further dice upgrade can be distributed.
  bool _canProceed() {
    if (_currentStage != LevelupStage.attributes) return true;
    final controller = _attributesController;
    if (controller == null) return true;
    return !controller.statValues
        .any((entry) => controller.canIncrease(entry.stat.getTypeId()));
  }

  void _proceed() {
    if (!_canProceed()) return;

    if (_currentStage == LevelupStage.health) {
      try {
        if (_canUpgradeAttributes) {
          _attributesController?.accept();
        }
        _healthController.applyHealthIncrease();
      } on StateError catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
        return;
      }
      _accepted = true;
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _currentStage = LevelupStage.values[_currentStage.index + 1];
    });
  }

  @override
  void dispose() {
    _attributesController?.cancel();
    if (!_accepted) {
      // Deferred, as firing update events during tree teardown would trigger setState on locked widgets.
      Future.microtask(widget.levelController.leveldown);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(textService.getText('text_levelup')),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('data/base/ui/bg/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Theme.of(context).canvasColor.withAlpha(180),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            // Bottom padding keeps content clear of the floating button.
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Center(
              child: Column(
                children: [
                  if (_canUpgradeAttributes &&
                      _currentStage == LevelupStage.attributes)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: AttributesWidget(
                        controller: _attributesController,
                        showUpgradeButtons: true,
                        onChanged: () => setState(() {}),
                      ),
                    )
                  else if (_currentStage == LevelupStage.health)
                    HealthLevelupWidget(controller: _healthController),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: EyuunWidgets.floatingActionButton(
        text: _currentStage == LevelupStage.health
            ? textService.getText('uitext_levelup_complete')
            : textService.getText('uitext_next'),
        onPressed: _canProceed() ? _proceed : null,
      ),
    );
  }
}

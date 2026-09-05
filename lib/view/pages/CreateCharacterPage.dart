import 'package:easy_stepper/easy_stepper.dart';
import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/controller/CharacterImageController.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/pages/MainPage.dart';
import 'package:eyuunapp/view/widgets/PickNewPathWidget.dart';
import 'package:eyuunapp/view/decoration/CircleDecoration.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/controller/CharacterGenerateStatsController.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/controller/PickUpbringingController.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:eyuuncore/controller/CharacterInitController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:eyuuncore/events/SessionCreatedEvent.dart';
import 'package:eyuuncore/events/SessionLoadEvent.dart';
import 'package:eyuuncore/events/SessionLoadedEvent.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/AttributeDiceSelector.dart';
import 'package:eyuunapp/view/widgets/CharacterPortraitPicker.dart';
import 'package:eyuunapp/view/widgets/UpbringingSelectionWidget.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuunapp/view/pages/SummaryPage.dart';
import 'package:eyuunapp/view/pages/TalentPage.dart';

class CreateCharacterPage extends StatefulWidget {
  const CreateCharacterPage({super.key, required this.title});
  final String title;

  @override
  State<CreateCharacterPage> createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage> {
  int currentStep = 0;
  var _leaveSessionOnDispose = true;

  late var steps = [
    EasyStep(title: 'Past', customStep: _buildStep(context)),
    EasyStep(title: 'Path', customStep: _buildStep(context)),
    EasyStep(title: 'Appearance', customStep: _buildStep(context)),
    EasyStep(title: 'Attributes', customStep: _buildStep(context)),
    EasyStep(title: 'Talents', customStep: _buildStep(context)),
    EasyStep(title: 'Summary', customStep: _buildStep(context)),
  ];

  late Entity character;

  late var pathController = PathController(character);
  late var characterBaseComponent = character.get<CharacterBaseComponent>()!;
  late var upbringingController =
      PickUpbringingController(characterBaseComponent);
  late var skillLearnerComponent = character.get<SkillLearnerComponent>();
  late var skillLearnerController = SkillLearnerController(
      skillLearner: skillLearnerComponent!, allowDowngrades: true);

  late var generateStatsController = CharacterGenerateStatsController(
      character.get<AttributesComponent>()!,
      healthComponent: character.get<HealthComponent>(),
      combatComponent: character.get<CombatComponent>(),
      fluxComponent: character.get<FluxComponent>(),
      inventoryComponent: character.get<InventoryComponent>(),
      languageLearnerComponent: character.get<LanguageLearnerComponent>());

  late var characterInitController = CharacterInitController(
      characterBaseComponent: character.get<CharacterBaseComponent>()!,
      fluxComponent: character.get<FluxComponent>(),
      healthComponent: character.get<HealthComponent>());

  late var pages = [
    _wrapWithLayoutBuilder(UpbringingSelectionWidget(
        characterBaseComponent: characterBaseComponent,
        upbringingController: upbringingController)),
    _wrapWithSizedBox(PickNewPathWidget(pathController: pathController)),
    _wrapWithSizedBox(CharacterPortraitPicker(
      nameable: NameableComponent("Glup Shitto"),
      upbringingController: upbringingController,
      imageController: CharacterImageController(characterBaseComponent),
    )),
    _wrapWithLayoutBuilder(AttributeDiceSelector(
        attributes: character.get<AttributesComponent>()!)),
    _wrapWithSizedBox(
        Center(child: TalentPage(controller: skillLearnerController))),
    SummaryPage(onCharacterCreated: _createCharacter),
  ];

  final ImageProvider placeholderImage = const NetworkImage(
      'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3');

  double desiredWidth = 1100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    character = locator<CharacterService>().character;
  }

  @override
  void dispose() {
    if (_leaveSessionOnDispose) {
      locator<SessionService>().leaveSession();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create your character"),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: const AssetImage('data/base/ui/bg/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    theme.canvasColor.withAlpha(180), BlendMode.srcOver)),
          ),
          child: Column(children: [
            Expanded(child: pages[currentStep]),
            EyuunWidgets.spacerVertical(),
            EasyStepper(
              steps: steps,
              lineStyle: const LineStyle(
                  lineThickness: 3,
                  unreachedLineType: LineType.dashed,
                  lineLength: 90,
                  lineType: LineType.normal,
                  activeLineColor: Colors.grey,
                  unreachedLineColor: Colors.grey,
                  defaultLineColor: Colors.orangeAccent),
              activeStepTextColor: Colors.black87,
              finishedStepTextColor: Colors.black87,
              activeStep: currentStep,
              titleTextStyle: theme.textTheme.headlineSmall,
              activeStepBackgroundColor: theme.secondaryHeaderColor,
              activeStepBorderType: BorderType.normal,
              activeStepBorderColor: Colors.white70,
              finishedStepBackgroundColor: theme.primaryColorLight,
              unreachedStepBackgroundColor: theme.canvasColor,
              borderThickness: 5,
              onStepReached: (value) {
                setState(() {
                  currentStep = value;
                });
              },
            )
          ])),
    );
  }

  Widget _buildStep(BuildContext context) {
    return Container(
        decoration: CircleDecoration(linePaint: Brushes.silverSparkling()));
  }

  Widget _wrapWithSizedBox(Widget widget) {
    return Center(
        child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: desiredWidth),
      child: widget,
    ));
  }

  Widget _wrapWithLayoutBuilder(Widget widget) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: desiredWidth),
                  child: widget,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _createCharacter() {
    _leaveSessionOnDispose = false;

    generateStatsController.finalizeStats();
    characterInitController.initCharacter();

    final character = locator<CharacterService>().character;
    final characterBase = character.get<CharacterBaseComponent>()!;
    final sessionService = locator<SessionService>();

    characterBase.characterState = CharacterState.Ingame;
    locator<EventBus>().fire(EntityUpdatedEvent(character, characterBase));
    locator<EventBus>()
        .fire(SessionCreatedEvent(sessionService.sessionId, character));
    locator<EventBus>().fire(SessionLoadEvent(sessionService.sessionId));
    locator<EventBus>()
        .fire(SessionLoadedEvent(sessionService.sessionId, character));
  }
}

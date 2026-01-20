import 'package:easy_stepper/easy_stepper.dart';
import 'package:eyuunapp/view/widgets/PickNewPathWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/CircleDecoration.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/controller/PickUpbringingController.dart';
import 'package:eyuuncore/controller/SkilllearnerController.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'package:eyuunapp/view/widgets/AttributeDiceSelector.dart';
import 'package:eyuunapp/view/widgets/CharacterPortraitPicker.dart';
import 'package:eyuunapp/view/widgets/UpbringingSelectionWidget.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';
import 'package:eyuunapp/view/pages/TalentPage.dart';

class CreateCharacterPage extends StatefulWidget {
  const CreateCharacterPage(
      {super.key, required this.title, required this.character});

  final String title;
  final Entity character;

  @override
  State<CreateCharacterPage> createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage> {
  int currentStep = 0;

  late var steps = [
    EasyStep(title: 'Past', customStep: _buildStep(context)),
    EasyStep(title: 'Path', customStep: _buildStep(context)),
    EasyStep(title: 'Appearance', customStep: _buildStep(context)),
    EasyStep(title: 'Attributes', customStep: _buildStep(context)),
    EasyStep(title: 'Talents', customStep: _buildStep(context)),
    EasyStep(title: 'Summary', customStep: _buildStep(context)),
  ];

  late var pathController = PathController(widget.character);
  late var characterBaseComponent =
      widget.character.get<CharacterBaseComponent>()!;
  late var upbringingController =
      PickUpbringingController(characterBaseComponent);
  late var skillLearnerComponent =
      widget.character.get<SkillLearnerComponent>();
  late var skillLearnerController = SkillLearnerController(
      skillLearner: skillLearnerComponent!, allowDowngrades: true);

  late var pages = [
    _wrapWithLayoutBuilder(UpbringingSelectionWidget(
        characterBaseComponent: characterBaseComponent,
        upbringingController: upbringingController)),
    _wrapWithSizedBox(PickNewPathWidget(pathController: pathController)),
    _wrapWithSizedBox(CharacterPortraitPicker(
      nameable: NameableComponent("Glup Shitto"),
      upbringingController: upbringingController,
    )),
    _wrapWithLayoutBuilder(AttributeDiceSelector(
        attributes: widget.character.get<AttributesComponent>()!)),
    _wrapWithSizedBox(
        Center(child: TalentPage(controller: skillLearnerController))),
    Center(
        child: Text(
            "A summary displaying your core choices and the create button"))
  ];

  final ImageProvider placeholderImage = const NetworkImage(
      'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3');

  double desiredWidth = 1100;

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
}

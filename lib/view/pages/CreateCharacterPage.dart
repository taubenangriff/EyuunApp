import 'package:eyuunapp/view/popup/PickPathPopup.dart';
import 'package:eyuunapp/view/widgets/Cards/AttributesWidget.dart';
import 'package:eyuunapp/view/widgets/Cards/CharacterInfoWidget.dart';
import 'package:eyuunapp/view/widgets/PickNewPathWidget.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/controller/PickUpbringingController.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import '../widgets/AttributeDiceSelector.dart';
import '../widgets/CharacterPortraitPicker.dart';
import '../widgets/UpbringingSelectionWidget.dart';
import '../widgets/eyuun/EyuunWidgets.dart';
import 'TalentPage.dart';

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

  var steps = [
    EasyStep(title: 'Past', customStep: Container()),
    EasyStep(title: 'Path', customStep: Container()),
    EasyStep(title: 'Appearance', customStep: Container()),
    EasyStep(title: 'Attributes', customStep: Container()),
    EasyStep(title: 'Talents', customStep: Container()),
    EasyStep(title: 'Summary', customStep: Container()),
  ];

  late var pathController = PathController(widget.character);
  late var characterBaseComponent =
      widget.character.get<CharacterBaseComponent>()!;
  late var upbringingController =
      PickUpbringingController(characterBaseComponent);

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
    _wrapWithSizedBox(Center(child: TalentPage())),
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
                    theme.canvasColor.withAlpha(180), BlendMode.srcOver)
            ),
          ),
          child: Column(children: [
            Expanded(child: pages[currentStep]),
            EyuunWidgets.spacerVertical(),
            EasyStepper(
              steps: steps,
              lineStyle: LineStyle(
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
              onStepReached: (value) {
                setState(() {
                  currentStep = value;
                });
              },
            )
          ])),
    );
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

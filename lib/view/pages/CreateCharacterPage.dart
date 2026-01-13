import 'package:EyuunApp/view/popup/PickPathPopup.dart';
import 'package:EyuunApp/view/widgets/Cards/AttributesWidget.dart';
import 'package:EyuunApp/view/widgets/Cards/CharacterInfoWidget.dart';
import 'package:EyuunApp/view/widgets/PickNewPathWidget.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

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
    EasyStep(title: 'Name', customStep: Container()),
    EasyStep(title: 'Past', customStep: Container()),
    EasyStep(title: 'Path', customStep: Container()),
    EasyStep(title: 'Attributes', customStep: Container()),
    EasyStep(title: 'Summary', customStep: Container()),
  ];

  late var pathController = PathController(widget.character);

  late var pages = [
    CharacterInfoWidget(
        profileImage: placeholderImage,
        name: "Glup Shitto",
        character: widget.character),
    CharacterInfoWidget(
        profileImage: placeholderImage,
        name: "Glup Shitto",
        character: widget.character),
    PickNewPathWidget(pathController: pathController),
    Center(child: AttributesWidget()),
    Center(
        child: Text(
            "A summary displaying your core choices and the create button"))
  ];

  final ImageProvider placeholderImage = const NetworkImage(
      'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double desiredWidth = 1100;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create your character"),
      ),
      body: Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: desiredWidth),
              child: pages[currentStep])),
      bottomNavigationBar: EasyStepper(
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
      ),
    );
  }
}

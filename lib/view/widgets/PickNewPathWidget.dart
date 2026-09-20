import 'dart:ui';
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';
import 'package:eyuunapp/view/widgets/PathHeaderTile.dart';
import 'package:eyuunapp/view/widgets/PathStepTile.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/popup/ConfirmPathPopup.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';

class PickNewPathWidget extends StatefulWidget {
  final PathController pathController;
  final void Function(Entity path)? onPathPicked;

  const PickNewPathWidget({
    super.key,
    required this.pathController,
    this.onPathPicked,
  });

  @override
  State<PickNewPathWidget> createState() => _PickNewPathWidgetState();
}

class _PickNewPathWidgetState extends State<PickNewPathWidget> {
  static const _carouselWeights = [1, 1, 2, 1, 1];

  final CarouselController _carouselController = CarouselController();
  final PathFeatureComponent pathFeature = locator<PathFeatureComponent>();
  final TextService textService = locator<TextService>();

  Entity? selectedPath;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectPath(pathFeature.paths[0]);
  }

  @override
  Widget build(BuildContext context) {
    final allPaths = pathFeature.paths
      ..sort((a, b) =>
          (a.get<PathComponent>()?.pathType.index ?? 0) -
          (b.get<PathComponent>()?.pathType.index ?? 0));

    final filteredPaths = allPaths.where((path) {
      final name = textService.getTextFromEntity(path).toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    final selectedSteps =
        selectedPath?.get<PathComponent>()?.pickableSteps ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildContent(filteredPaths, selectedSteps),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: textService.getText('uitext_searchpath'),
      ),
      onChanged: (value) => setState(() => searchQuery = value),
    );
  }

  Widget _buildContent(
    List<Entity> filteredPaths,
    List<Entity> selectedSteps,
  ) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: selectedPath == null
              ? Center(
                  child: Text(
                    textService.getText('uitext_selectpath'),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(4),
                  child: ListView.separated(
                    itemCount: selectedSteps.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final pathStep = selectedSteps[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: PathStepTile(
                          pathStep: pathStep,
                          pathController: widget.pathController,
                          onTap: widget.pathController.canPickStep(pathStep)
                              ? () async {
                                  final confirmed = await PopupUtil.popup<bool>(
                                    maximumSize: Size(400, 700),
                                    context,
                                    ConfirmPathPopup(pathStep: pathStep),
                                  );
                                  if (!mounted || confirmed != true) return;

                                  setState(() {
                                    widget.pathController.pickStep(pathStep);
                                    widget.onPathPicked?.call(selectedPath!);
                                  });
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                ),
        ),
        EyuunWidgets.spacerVertical(),
        Expanded(
          child: filteredPaths.isNotEmpty
              ? ScrollConfiguration(
                  behavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: CarouselView.weightedBuilder(
                    controller: _carouselController,
                    flexWeights: _carouselWeights,
                    itemSnapping: true,
                    infinite: true,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    itemCount: filteredPaths.length,
                    onIndexChanged: (selectedIndex) {
                      final middleIndex =
                          (selectedIndex + 2) % filteredPaths.length;
                      _selectPath(filteredPaths[middleIndex]);
                    },
                    itemBuilder: (context, index) {
                      final path = filteredPaths[index];
                      return AnimatedScale(
                        scale: selectedPath == path ? 0.96 : 0.86,
                        duration: const Duration(milliseconds: 150),
                        child: PathHeaderTile(pathEntity: path),
                      );
                    },
                  ),
                )
              : const Center(child: Text('!Your search yielded no results')),
        ),
      ],
    );
  }

  void _selectPath(Entity path) {
    if (selectedPath == path) return;
    setState(() {
      selectedPath = path;
    });
  }

  Widget _buildBottomButton() {
    final canPick =
        selectedPath != null && widget.pathController.canPickNewPath();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 50,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: ArtDecoBoxDecoration(
              cornerBuilder: (p) => DoubleLineCornerPainter(p),
              verticalLineBuilder: (p) => DoubleLinePainter(p),
              horizontalLineBuilder: (p) => DoubleLinePainter(p),
              paint: Brushes.goldSparkling()..strokeWidth = 1.25,
              cornerSize: 16),
          child: ElevatedButton(
            onPressed: canPick
                ? () {
                    widget.pathController.pickNewPath(selectedPath!);
                    widget.onPathPicked?.call(selectedPath!);
                  }
                : null,
            child: selectedPath != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      Text(
                        '${textService.getText('uitext_addpath')} '
                        '${textService.getTextFromEntity(selectedPath)}',
                      ),
                    ],
                  )
                : Text(
                    textService.getText('uitext_selectpath_02'),
                  ),
          ),
        ),
      ),
    );
  }
}

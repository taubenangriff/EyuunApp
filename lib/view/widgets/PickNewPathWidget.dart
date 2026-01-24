import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/widgets/ItemWheel.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';
import 'package:eyuunapp/view/widgets/PathHeaderTile.dart';
import 'package:eyuunapp/view/widgets/PathStepTile.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
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
  final PathFeatureComponent pathFeature = locator<PathFeatureComponent>();
  final TextService textService = locator<TextService>();

  Entity? selectedPath;
  String searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
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
        padding: const EdgeInsets.all(24),
        child: _buildContent(filteredPaths, selectedSteps),
      ),
      floatingActionButton: _buildBottomButton(),
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
        _buildSearchBar(),
        EyuunWidgets.spacerVertical(),
        Expanded(
          flex: 3,
          child: selectedPath == null
              ? Center(
                  child: Text(
                    textService.getText('uitext_selectpath'),
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              : ListView.separated(
                  itemCount: selectedSteps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    return PathStepTile(
                      pathStep: selectedSteps[index],
                      pathController: widget.pathController,
                      canPick: false,
                    );
                  },
                ),
        ),
        EyuunWidgets.spacerVertical(),
        Expanded(
            child: filteredPaths.isNotEmpty ? ItemWheel(
                maxValue: filteredPaths.length - 1,
                startValue: filteredPaths.length -1,
                customSize: 200,
                valueIsIndex: true,
                horizontal: true,
                perspective: 0.002,
                useMagnifier: false,
                customMargin: 6,
                valueCallback: (selectedIndex) {
                  final path = filteredPaths[selectedIndex];
                  setState(() {
                    selectedPath = path;
                  });
                },
                childWidget: (index) {
                  final path = filteredPaths[index];
                  return PathHeaderTile(pathEntity: path);
                })
                : Center(child: Text('!Your search yielded no results'))),
        SizedBox(height: 60)
      ],
    );
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
              paint: Brushes.goldSparkling()
                ..strokeWidth = 1.25,
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

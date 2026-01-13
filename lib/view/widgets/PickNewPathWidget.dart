import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'PathHeaderTile.dart';
import 'PathStepTile.dart';
import 'eyuun/Brushes.dart';
import 'eyuun/EyuunDecoration.dart';

class PickNewPathWidget extends StatefulWidget {
  final PathController pathController;
  final void Function(String pathId)? onPathPicked;

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

  String? selectedPathId;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allPaths = pathFeature.paths.getAssets()
      ..sort((a, b) =>
          (a.get<PathComponent>()?.pathType.index ?? 0) -
          (b.get<PathComponent>()?.pathType.index ?? 0));

    final filteredPaths = allPaths.where((path) {
      final name = textService.getTextFromEntity(path).toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    final selectedPath = selectedPathId == null
        ? null
        : allPaths.firstWhere(
            (p) => p.getTypeId() == selectedPathId,
            orElse: () => allPaths.first,
          );

    final selectedSteps =
        selectedPath?.get<PathComponent>()?.pickableSteps.getAssets() ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContent(filteredPaths, selectedPath, selectedSteps),
            ),
            const SizedBox(height: 60),
          ],
        ),
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
    Entity? selectedPath,
    List<Entity> selectedSteps,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView.separated(
            itemCount: filteredPaths.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final path = filteredPaths[index];
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(
                  () => selectedPathId = path.getTypeId(),
                ),
                child: PathHeaderTile(pathEntity: path),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
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
      ],
    );
  }

  Widget _buildBottomButton() {
    final canPick =
        selectedPathId != null && widget.pathController.canPickNewPath();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 50,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: EyuunDecoration(
            paint: Brushes.goldSparkling(),
            cornerSize: 12,
          ),
          child: ElevatedButton(
            onPressed: canPick
                ? () {
                    widget.pathController.pickNewPath(selectedPathId!);
                    widget.onPathPicked?.call(selectedPathId!);
                  }
                : null,
            child: selectedPathId != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      Text(
                        '${textService.getText('uitext_addpath')} '
                        '${textService.getText(selectedPathId!)}',
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

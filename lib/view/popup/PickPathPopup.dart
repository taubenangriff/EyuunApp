import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/controller/PathController.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';

import '../widgets/eyuun/Brushes.dart';
import '../widgets/eyuun/EyuunDecoration.dart';
import '../widgets/PathHeaderTile.dart';
import '../widgets/PathStepTile.dart';

class PickPathPopup extends StatefulWidget {
  final PathController pathController;
  final PathFeatureComponent pathFeature = locator<PathFeatureComponent>();
  final void Function(String pathId)? onPathPicked;
  final TextService textService = locator<TextService>();

  PickPathPopup({
    super.key,
    required this.pathController,
    this.onPathPicked,
  });

  @override
  State<PickPathPopup> createState() => _PickPathPopupState();
}

class _PickPathPopupState extends State<PickPathPopup> {
  String? selectedPathId;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allPaths = widget.pathFeature.paths.getAssets();

    // sort by pathType
    allPaths.sort((x, y) => x.get<PathComponent>()?.pathType.index ?? 0 - (y.get<PathComponent>()?.pathType.index ?? 0));

    //remove Paths we already picked.
    //TODO uncomment this again
    //allPaths.removeWhere((e) => widget.pathController.isPathPicked(e.getTypeId()));

    final filteredPaths = allPaths.where((path) {
      final name = widget.textService.getTextFromEntity(path).toLowerCase();
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

    return DecoratedBox(
      decoration: EyuunDecoration(
        paint: Brushes.silverSparkling(),
        cornerSize: 12,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 🔍 Search bar
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: widget.textService.getText('uitext_searchpath'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 🧱 Main content
                Expanded(
                  child: Row(
                    children: [
                      // ⬅️ Left: Path list
                      Expanded(
                        flex: 1,
                        child: ListView.separated(
                          itemCount: filteredPaths.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final path = filteredPaths[index];
                            final typeId = path.getTypeId();

                            return InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                setState(() {
                                  selectedPathId = typeId;
                                });
                              },
                              child: PathHeaderTile(pathEntity: path),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ➡️ Right: Path steps
                      Expanded(
                        flex: 2,
                        child: selectedPath == null
                            ?  Center(
                                child: Text(
                                  widget.textService.getText('uitext_selectpath'),
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: selectedSteps.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final step = selectedSteps[index];

                                  return PathStepTile(
                                    pathStep: step,
                                    pathController: widget.pathController,
                                    canPick: false,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),

          // ➕ Add path button
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                      height: 50,
                      child: DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: EyuunDecoration(
                              paint: Brushes.goldSparkling(), cornerSize: 12),
                          child: ElevatedButton(
                            onPressed: selectedPathId != null &&
                                    widget.pathController.canPickNewPath()
                                ? () {
                                    widget.pathController
                                        .pickNewPath(selectedPathId!);
                                    widget.onPathPicked?.call(selectedPathId!);
                                  }
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: selectedPathId != null ? [
                                Icon(Icons.add),
                                Text(
                                    '${widget.textService.getText('uitext_addpath')} ${widget.textService.getText(selectedPathId!)}')
                              ] : [
                                Text(widget.textService.getText('uitext_selectpath_02'))
                              ],
                            ),
                          ))))),
        ],
      ),
    );
  }
}

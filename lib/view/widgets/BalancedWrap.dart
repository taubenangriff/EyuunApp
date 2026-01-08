import 'package:flutter/material.dart';

class BalancedWrap extends StatelessWidget {
  final List<Widget> children;
  final double minColumnWidth;
  final double horizontalSpacing;
  final double verticalSpacing;

  const BalancedWrap({
    super.key,
    required this.children,
    this.minColumnWidth = 200,
    this.horizontalSpacing = 12,
    this.verticalSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        // How many columns fit?
        final columnCount =
        (maxWidth / minColumnWidth).floor().clamp(1, children.length);

        // Prepare columns
        final columns = List.generate(columnCount, (_) => <Widget>[]);

        // Distribute items evenly (round-robin)
        for (var i = 0; i < children.length; i++) {
          columns[i % columnCount].add(
            Padding(
              padding: EdgeInsets.only(bottom: verticalSpacing),
              child: children[i],
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < columns.length; i++) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: columns[i],
                ),
              ),
              if (i < columns.length - 1)
                SizedBox(width: horizontalSpacing),
            ],
          ],
        );
      },
    );
  }
}

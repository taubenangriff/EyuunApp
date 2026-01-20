import 'package:flutter/material.dart';

import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/widgets/eyuun/Brushes.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunDecoration.dart';
import 'package:eyuunapp/view/widgets/eyuun/EyuunWidgets.dart';

class MoneyChangePopup extends StatefulWidget {
  const MoneyChangePopup(
    this.changeVal, {
    this.setState,
    this.valueChanged,
    super.key,
  });

  final ChangeValueController changeVal;
  final void Function(void Function())? setState;
  final void Function(int)? valueChanged;

  @override
  State<MoneyChangePopup> createState() => _MoneyChangePopupState();
}

class _MoneyChangePopupState extends State<MoneyChangePopup> {
  static const List<int> banknotes = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000];

  final Map<int, int> selectedNotes = {};

  final int maxCount = 99;

  int get totalSelected =>
      selectedNotes.entries.fold(0, (sum, e) => sum + e.key * e.value);

  void _addNote(int value) {
    setState(() {
      if (selectedNotes[value] != null && selectedNotes[value]! >= maxCount) {
        return;
      }
      selectedNotes[value] = (selectedNotes[value] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sortedSelection = selectedNotes.entries.toList();
    sortedSelection.sort((x, y) => x.key.compareTo(y.key));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedSelection.length,
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                        140, // roughly matches your banknote width
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        mainAxisExtent: 50,
                      ),
                      itemBuilder: (context, index) {
                        final entry = sortedSelection[index];
                        return _BanknoteDisplay(
                          showCount: true,
                          value: entry.key,
                          count: entry.value,
                          onTap: () => _removeNote(entry.key),
                        );
                      })),
              SizedBox(
                  width: 120,
                  child: Center(
                    child:
                    // 💰 Total amount
                    Text(
                      '= $totalSelected¥',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          )

          // 🧾 Selected banknotes (aggregated)
          ,

          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 16),
          Text('Select banknotes to add them to the counter'),
          const SizedBox(height: 16),

          // ➕ Banknote buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: banknotes.map((value) {
              return _BanknoteDisplay(
                value: value,
                onTap: () => _addNote(value),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            EyuunWidgets.floatingActionButton(
              height: 60,
              text: 'Spend',
              onPressed: totalSelected < widget.changeVal.maxLosable()
                  ? () {
                widget.valueChanged?.call(-totalSelected);
                Navigator.of(context).pop();
              }
                  : null,
            ),
            SizedBox(width: 16),
            EyuunWidgets.floatingActionButton(
              height: 60,
              text: 'Receive',
              onPressed: () {
                widget.valueChanged?.call(totalSelected);
                Navigator.of(context).pop();
              },
            ),
          ])
        ],
      ),
    );
  }

  void _removeNote(int value) {
    setState(() {
      final current = selectedNotes[value];
      if (current == null) return;

      if (current <= 1) {
        selectedNotes.remove(value);
      } else {
        selectedNotes[value] = current - 1;
      }
    });
  }
}

class _BanknoteDisplay extends StatelessWidget {
  final int value;
  final int count;
  final VoidCallback onTap;
  final bool showCount;

  const _BanknoteDisplay(
      {required this.value,
      this.count = 1,
      required this.onTap,
      this.showCount = false});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCount)
              SizedBox(
                  width: 30,
                  child: showCount && count > 1
                      ? Text(
                          '$count× ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null),
            SizedBox(
                width: 75,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.zero,
                  child: DecoratedBox(
                    decoration: EyuunDecoration(
                      fillCorners: false,
                      paint: Brushes.silverSparkling(),
                      cornerSize: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        '$value ¥',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}

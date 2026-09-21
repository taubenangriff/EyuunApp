import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/widgets/ItemWheel.dart';
import 'package:flutter/material.dart';

class ChangeFluxPopup extends StatefulWidget {
  const ChangeFluxPopup(
    this.currentController,
    this.capacityController, {
    this.onAccept,
    this.horizontal = false,
    super.key,
  });

  final ChangeValueController currentController;
  final ChangeValueController capacityController;
  final void Function()? onAccept;
  final bool horizontal;

  @override
  State<ChangeFluxPopup> createState() => _ChangeFluxPopupState();
}

class _ChangeFluxPopupState extends State<ChangeFluxPopup> {
  int currentChange = 0;
  late int selectedCapacity = widget.capacityController.value;

  Widget _valueColumn(String label, String value) {
    return SizedBox(
      width: 60,
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26)),
        ],
      ),
    );
  }

  Widget _changeColumn({
    Key? key,
    required String label,
    required int value,
    required int minValue,
    required int maxValue,
    int? startValue,
    bool showSignedValues = false,
    required void Function(int) onChanged,
  }) {
    return SizedBox(
      width: 60,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          SizedBox(
            width: 80,
            height: 150,
            child: ItemWheel(
              key: key,
              startValue: startValue ?? value,
              valueCallback: onChanged,
              minValue: minValue,
              maxValue: maxValue,
              addLeadingPlus: showSignedValues,
              horizontal: widget.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  void _apply() {
    widget.capacityController
        .change(selectedCapacity - widget.capacityController.value);
    widget.currentController.maxLimit = widget.capacityController.value;
    widget.currentController.change(currentChange);
    widget.onAccept?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final newCurrent = widget.currentController.value + currentChange;
    final newCapacity = selectedCapacity;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _valueColumn(
                  'Old',
                  '${widget.currentController.value}',
                ),
                _changeColumn(
                  key: ValueKey('current-$newCapacity'),
                  label: '',
                  value: newCurrent,
                  minValue: -widget.currentController.maxLosable(),
                  maxValue: newCapacity - widget.currentController.value,
                  startValue: currentChange,
                  showSignedValues: true,
                  onChanged: (value) => setState(() => currentChange = value),
                ),
                _valueColumn('New', '$newCurrent'),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('of'),
                ),
                _changeColumn(
                  label: 'Capacity',
                  value: newCapacity,
                  minValue: widget.capacityController.minLimit,
                  maxValue: widget.capacityController.maxLimit,
                  startValue: selectedCapacity,
                  onChanged: (value) => setState(() {
                    selectedCapacity = value;
                    currentChange = currentChange.clamp(
                        -widget.currentController.maxLosable(),
                        selectedCapacity - widget.currentController.value);
                  }),
                ),
              ],
            ),
            SizedBox(
              width: 178,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: ArtDecoBoxDecoration(
                    cornerBuilder: (p) => DoubleLineCornerPainter(p),
                    verticalLineBuilder: (p) => DoubleLinePainter(p),
                    horizontalLineBuilder: (p) => DoubleLinePainter(p),
                    paint: Brushes.goldSparkling()..strokeWidth = 1.5,
                    cornerSize: 12,
                  ),
                  child: FloatingActionButton(
                    onPressed: _apply,
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Color(0xccfdcc3a)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

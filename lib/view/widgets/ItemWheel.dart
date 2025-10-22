import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flutter/material.dart';

import 'SelectableValue.dart';

class ItemWheel extends StatefulWidget {
  ItemWheel({
    super.key,
    required this.maxValue,
    required this.valueCallback,
    this.minValue = 0,
    this.startValue = 0,
    this.childWidget,
    this.horizontal = false,
    this.valueIsIndex = false,
    this.customSize = 30.0,
    this.customMargin = 0,
  }) {
    childCount = maxValue - minValue + 1;
  }

  late final int childCount;
  final Widget Function(int)? childWidget;
  final void Function(int)? valueCallback;
  final bool horizontal;
  final bool valueIsIndex;
  final double customSize;
  final double customMargin;

  final int startValue;

  int maxValue;
  int minValue;

  @override
  State<ItemWheel> createState() => _ItemWheelState();
}

class _ItemWheelState extends State<ItemWheel> {

  late int value;

  late final FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    value = widget.startValue;

    scrollController = FixedExtentScrollController(
        initialItem: widget.valueIsIndex
            ? value
            : widget.maxValue - value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RotatedBox(
        quarterTurns: widget.horizontal ? 1 : 0,
        child: ListWheelScrollView.useDelegate(
          perspective: 0.005,
          physics: const FixedExtentScrollPhysics(),
          controller: scrollController,
          scrollBehavior: const MaterialScrollBehavior(),
          itemExtent: widget.customSize,
          useMagnifier: true,
          magnification: 1.5,
          diameterRatio: 2.5,
          childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.childCount,
              builder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(widget.customMargin),
                  child: RotatedBox(
                      quarterTurns: widget.horizontal ? 3 : 0,
                      child: (widget.childWidget != null)
                          ? (widget.childWidget!.call(index))
                          : SelectableValue(
                              value: widget.valueIsIndex
                                  ? index
                                  : widget.maxValue -
                                      index,
                              isSelected: index ==
                                  (widget.valueIsIndex
                                      ? value
                                      : widget.maxValue -
                                          value),
                            )),
                );
              }),
          onSelectedItemChanged: (index) {
            if (widget.valueIsIndex) {
              value = index;
            } else {
              value = widget.maxValue - index;
            }
            setState(() {});
            widget.valueCallback!(value);
          },
        ),
      ),
    );
  }
}

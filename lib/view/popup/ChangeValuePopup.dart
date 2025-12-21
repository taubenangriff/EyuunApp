import 'package:EyuunApp/view/controller/ChangeValueController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/ItemWheel.dart';

class ChangeValuePopup extends StatefulWidget {
  const ChangeValuePopup(this.changeVal,
      {this.setState, this.horizontal = false, this.valueChanged, super.key});

  final ChangeValueController changeVal;
  final void Function(void Function())? setState;
  final bool horizontal;
  final void Function(int)? valueChanged;

  @override
  State<ChangeValuePopup> createState() => _ChangeValuePopupState();
}

class _ChangeValuePopupState extends State<ChangeValuePopup> {
  late int newVal = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Row(children: [
            SizedBox(
              height: 50,
              width: 100,
              child: Text('${widget.changeVal.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30)),
            ),
            SizedBox(
                height: 200,
                width: 100,
                child: ItemWheel(
                    valueCallback: (i) => setState(() {
                          newVal = i;
                        }),
                    maxValue: widget.changeVal.maxGainable(),
                    minValue: -widget.changeVal.maxLosable(),
                    horizontal: widget.horizontal)),
            SizedBox(
              height: 50,
              width: 100,
              child: Text("${widget.changeVal.value + newVal}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30)),
            )
          ]),
        ),
        SizedBox(
            width: 128,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: FloatingActionButton(
                    onPressed: () {
                      widget.valueChanged?.call(newVal);
                      Navigator.of(context).pop();
                    },
                    child: Text('Apply'))))
      ],
    );
  }
}

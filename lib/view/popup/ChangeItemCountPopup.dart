import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/ItemWheel.dart';

class ChangeItemCountPopup extends StatefulWidget {
  const ChangeItemCountPopup(this.changeVal,
      {this.setState, this.horizontal = false, this.valueChanged, super.key});

  final ChangeValueController changeVal;
  final void Function(void Function())? setState;
  final bool horizontal;
  final void Function(int, bool)? valueChanged;

  @override
  State<ChangeItemCountPopup> createState() => _ChangeItemCountPopupState();
}

class ChangeItemCountType {
  IconData iconData;
  String name;
  String negativeName;

  ChangeItemCountType(this.name, this.negativeName, this.iconData);
}

class _ChangeItemCountPopupState extends State<ChangeItemCountPopup> {
  late List<ChangeItemCountType> icons = [
    ChangeItemCountType("Add", "Remove", Icons.add),
    ChangeItemCountType("Buy", "Sell", Icons.euro)
  ];

  late int selectedIndex = 0;

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
        Text( newVal >= 0 ? icons[selectedIndex].name : icons[selectedIndex].negativeName, style: TextStyle(fontSize: 24)),
        SizedBox(
            width: 200,
            height: 80,
            child: ItemWheel(
                maxValue: 1,
                valueIsIndex: true,
                valueCallback: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                childWidget: (index) => Icon(icons[index].iconData, color: index != selectedIndex ? Colors.grey.shade600 : Colors.grey.shade300),
                horizontal: true)),
        SizedBox(
            width: 128,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: FloatingActionButton(
                    onPressed: () {
                      widget.valueChanged!(newVal, false);
                      Navigator.of(context).pop();
                    },
                    child: Text('Apply'))))
      ],
    );
  }
}

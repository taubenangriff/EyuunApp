import 'package:flutter/material.dart';

//SelectableValue copypasta from previous flexapp
class SelectableValue extends StatelessWidget {
  final dynamic value;
  final bool isSelected;
  const SelectableValue({super.key, required this.value, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
          child: Text(value.toString(),
              textScaler: const TextScaler.linear(1.2),
              style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey )
          )),

    );
  }
}
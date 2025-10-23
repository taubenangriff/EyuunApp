import 'dart:math';

import 'package:flexbackend/view/controller/ChangeValueController.dart';
import 'package:flexbackend/view/popup/ChangeValuePopup.dart';
import 'package:flexbackend/view/widgets/CharacterInfoWidget.dart';
import 'package:flexbackend/view/widgets/PathsWidget.dart';
import 'package:flexbackend/view/widgets/BaseValues.dart';
import 'package:flutter/material.dart';
import 'package:flexbackend/view/popup/PopupUtil.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    late double desiredSize = 900;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: Text('Inventory'))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLargeFab(
            onPressed: () {
            },
            text: '1400 €',
            tooltip: 'Yuun',
            icon: Icons.money,
          )
        ],
      ),
    );
  }

  Widget _buildLargeFab(
      {required IconData icon,
        required VoidCallback onPressed,
        required String text,
        String tooltip = ""}) {
    return SizedBox(
        width: 120,
        height: 80,
        child: FloatingActionButton(
            heroTag: text,
            tooltip: tooltip,
            onPressed: onPressed,
            child: Row(
                mainAxisSize:
                MainAxisSize.min, // 👈 prevents Row from stretching
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(icon, size: 36), Text(text)])));
  }
}

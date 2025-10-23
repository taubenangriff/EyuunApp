import 'dart:math';

import 'package:flexbackend/view/CharacterPage.dart';
import 'package:flexbackend/view/InventoryPage.dart';
import 'package:flutter/material.dart';

import 'CombatPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final _pages = [
    const Center(child: CharacterPage()),
    const Center(child: CombatPage()),
    const Center(child: Text("Talents")),
    const Center(child: InventoryPage()),
    const Center(child: Text("Notes")),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 750;


    return Scaffold(
      appBar: AppBar(
        title: Text("Eyuun App"),
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              extended: true,
              minExtendedWidth: 180,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _changeDestination,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.person_2_outlined),
                  selectedIcon: Icon(Icons.person_2),
                  label: Text('Character'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.abc_outlined),
                  selectedIcon: Icon(Icons.abc),
                  label: Text('Combat'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.star_outline),
                  selectedIcon: Icon(Icons.star),
                  label: Text('Talents'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: Text('Inventory'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.speaker_notes_outlined),
                  selectedIcon: Icon(Icons.speaker_notes),
                  label: Text('Notes'),
                )
              ],
            ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child:_pages[_selectedIndex]
          )),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _changeDestination,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.person_2_outlined),
                  selectedIcon: Icon(Icons.person_2),
                  label: 'Character',
                ),
                NavigationDestination(
                    icon: Icon(Icons.abc_outlined),
                    selectedIcon: Icon(Icons.abc),
                    label: 'Combat'),
                NavigationDestination(
                  icon: Icon(Icons.star_outline),
                  selectedIcon: Icon(Icons.star),
                  label: 'Talents',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: 'Inventory',
                ),
                NavigationDestination(
                  icon: Icon(Icons.speaker_notes_outlined),
                  selectedIcon: Icon(Icons.speaker_notes),
                  label: 'Notes',
                )
              ],
            ),
    );
  }

  _changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

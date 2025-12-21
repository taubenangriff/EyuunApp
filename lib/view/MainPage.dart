import 'dart:convert';
import 'dart:math';

import 'package:EyuunApp/view/CharacterPage.dart';
import 'package:EyuunApp/view/InventoryPage.dart';
import 'package:flutter/material.dart';

import 'dart:html' as html;

import '../core/registerServices.dart';
import '../core/services/CharacterService.dart';
import '../io/AssetSerializer.dart';
import 'CombatPage.dart';
import 'TalentPage.dart';

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
    const Center(child: TalentPage()),
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
          if(isWide)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            var charJson = json.encode(locator<AssetSerializer>().serialize(locator<CharacterService>().character));
            downloadConfig(charJson);
          });
        },
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

@Deprecated("This code is only ever placeholder to download the character!!")
//Some code to just download the character as json
void downloadConfig(String data) {
  final blob = html.Blob([data]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'config.json')
    ..click();
  html.Url.revokeObjectUrl(url);
}
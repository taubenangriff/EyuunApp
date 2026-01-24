import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/DoubleLineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/ThickThinThickCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/ThickThinThickLinePainter.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class CharacterOverview {
  final String id;
  final String name;
  final String upbringing;
  final int level;
  final DateTime lastModified;
  final String creatorName;
  final ImageProvider image;

  CharacterOverview({
    required this.id,
    required this.name,
    required this.upbringing,
    required this.level,
    required this.lastModified,
    required this.creatorName,
    required this.image,
  });
}

final List<CharacterOverview> placeholderCharacters = [
  CharacterOverview(
    id: 'f8',
    name: 'Rainer Winkler',
    upbringing: 'Schanzenbewohner',
    level: 11,
    lastModified: DateTime.now().subtract(const Duration(days: 30)),
    creatorName: 'Rudi & Rita Winkler',
    image: const NetworkImage(
        'https://i.scdn.co/image/ab676161000051746e6cb7c255477a5588e311fd'),
  ),
  CharacterOverview(
    id: 'f1',
    name: 'Sir Crashalot',
    upbringing: 'Knightly Aspirant (Failed)',
    level: 2,
    lastModified: DateTime.now().subtract(const Duration(minutes: 42)),
    creatorName: 'QA Department',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f2',
    name: 'Mildred the Adequate',
    upbringing: 'Barely Trained Apprentice',
    level: 3,
    lastModified: DateTime.now().subtract(const Duration(days: 5)),
    creatorName: 'Mildred',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f3',
    name: 'Grunk',
    upbringing: 'Raised by Something (Unclear)',
    level: 6,
    lastModified: DateTime.now().subtract(const Duration(hours: 1)),
    creatorName: 'Grunk',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f4',
    name: 'Professor Whifflebottom',
    upbringing: 'Academically Overqualified',
    level: 9,
    lastModified: DateTime.now().subtract(const Duration(days: 12)),
    creatorName: 'Prof. Whifflebottom',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f5',
    name: 'Stabby McPeaceful',
    upbringing: 'Pacifist Commune',
    level: 5,
    lastModified: DateTime.now().subtract(const Duration(hours: 18)),
    creatorName: 'Irony Engine',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f6',
    name: 'Kevin',
    upbringing: 'Extremely Normal Childhood',
    level: 1,
    lastModified: DateTime.now().subtract(const Duration(minutes: 3)),
    creatorName: 'Kevin',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f7',
    name: 'Lady Overprepared',
    upbringing: 'Survivalist Bunker',
    level: 8,
    lastModified: DateTime.now().subtract(const Duration(days: 2)),
    creatorName: 'Paranoia Inc.',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
  CharacterOverview(
    id: 'f8',
    name: 'The Chosen One (Again)',
    upbringing: 'Prophecy Factory',
    level: 11,
    lastModified: DateTime.now().subtract(const Duration(days: 30)),
    creatorName: 'Narrative Convenience',
    image: const NetworkImage(
        'https://tse3.mm.bing.net/th/id/OIP.cPOpHmPNSfuOjLHJxKOFzAHaGe?rs=1&pid=ImgDetMain&o=7&rm=3'),
  ),
];

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  final double desiredSize = 1100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Select Character')),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('data/base/ui/bg/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: desiredSize),
                child: GridView.builder(
                  itemCount: placeholderCharacters.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.55,
                    maxCrossAxisExtent: 300,
                  ),
                  itemBuilder: (context, index) {
                    final character = placeholderCharacters[index];
                    return _CharacterCard(
                      character: character,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MainPage(title: 'Eyuun App'),
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
        ));
  }
}

class _CharacterCard extends StatelessWidget {
  final CharacterOverview character;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
        elevation: 8,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: ArtDecoBoxDecoration(
              cornerBuilder: (p) => DoubleLineCornerPainter(p),
              verticalLineBuilder: (p) => DoubleLinePainter(p),
              horizontalLineBuilder: (p) => DoubleLinePainter(p),
              paint: Brushes.goldSparkling()..strokeWidth = 1.25,
              cornerSize: 20),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🖼 Image (1x1)
                AspectRatio(
                  aspectRatio: 1,
                  child: Image(
                    image: character.image,
                    fit: BoxFit.cover,
                  ),
                ),

                // 📜 Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        character.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Upbringing: ${character.upbringing}'),
                      Text('Level ${character.level}'),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Spacer(),
                // 📜 Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Modified: ${character.lastModified}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Creator: ${character.creatorName}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

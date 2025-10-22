import 'package:flutter/material.dart';

class PathPopup extends StatefulWidget {
  final void Function(String)? onSubmitted;
  final void Function(void Function())? setState;

  const PathPopup({this.onSubmitted, this.setState, super.key});

  @override
  State<PathPopup> createState() => _PathPopupState();
}

class _PathPopupState extends State<PathPopup> {
  static const description =
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et';

  static const List<String> descriptions = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII'
  ];

  var maxSkilled = 1;
  bool canSelectNew = true;

  _increasePath() {
    setState(() {
      maxSkilled++;
      canSelectNew = false;
    });
  }

  _buildPath(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child:  Row(children: [
        SizedBox(
          width: 30,
          child: Text(
            descriptions[i],
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 10),
        Flexible(
            child: Text(
              description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 15,
                  color: i < maxSkilled
                      ? Colors.grey.shade400
                      : (i == maxSkilled && canSelectNew
                      ? Colors.orangeAccent
                      : Colors.grey.shade700)),
            ))
      ])
    );


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            const Text(
              'Path Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < descriptions.length; i++) ...[
              canSelectNew && i == maxSkilled
                  ? InkWell(
                      onTap: _increasePath,
                      child: Container(
                          decoration: BoxDecoration(
                            // optional background
                            border: Border.all(
                              color: Colors.orangeAccent, // border color
                              width: 1, // border thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(8), // rounded corners
                          ),
                          child: _buildPath(i)))
                  :
                  //these paths are just for display.
                  _buildPath(i),

              if (i != descriptions.length - 1) ...[
                const SizedBox(height: 4),
                Icon(Icons.arrow_downward,
                    size: 36,
                    color: i < maxSkilled-1
                        ? Colors.green
                        : (i == maxSkilled-1 && canSelectNew
                            ? Colors.orangeAccent
                            : Colors.grey.shade700)),
                const SizedBox(height: 4),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

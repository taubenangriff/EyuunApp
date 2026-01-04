import 'package:flutter/material.dart';

import 'SelectFile.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String selectedAsset = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            child: SelectFileWidget(
              onFileSelected: (file) {
                setState(() {
                  selectedAsset = file.path;
                });
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Text(
                selectedAsset.isEmpty
                    ? "Example with custom icons"
                    : "Selected: $selectedAsset",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 128,
        child: FloatingActionButton(
          onPressed: () {
            // export
          },
          tooltip: "Export assets",
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.save), SizedBox(width: 8), Text("Export")],
          ),
        ),
      ),
    );
  }
}

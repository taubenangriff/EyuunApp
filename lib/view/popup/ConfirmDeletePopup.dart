import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:flutter/material.dart';

class ConfirmDeletePopup extends StatelessWidget {
  final String characterName;

  const ConfirmDeletePopup({
    super.key,
    required this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Delete Character',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Are you sure you want to delete "$characterName"? This operation cannot be undone.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EyuunWidgets.floatingActionButton(
                text: 'Cancel',
                width: 100,
                height: 40,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              EyuunWidgets.floatingActionButton(
                text: 'Delete',
                width: 100,
                height: 40,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

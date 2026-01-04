import 'package:flutter/material.dart';

import '../Asset.dart';

class AssetWidget extends StatefulWidget {
  final Asset asset;

  const AssetWidget({
    super.key,
    required this.asset,
  });

  @override
  State<AssetWidget> createState() => _AssetWidgetState();
}

class _AssetWidgetState extends State<AssetWidget> {
  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        asset.toString(), // replace with real asset fields
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

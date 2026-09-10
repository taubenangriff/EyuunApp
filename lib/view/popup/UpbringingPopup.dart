import 'package:eyuunapp/view/widgets/BuffDisplay.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

class UpbringingPopup extends StatelessWidget {
  final Entity? primary;
  final List<Entity> visuals;

  const UpbringingPopup({
    required this.primary,
    required this.visuals,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UpbringingColumn(
              title:
                  locator<TextService>().getText("uitext_primary_upbringing"),
              entity: primary,
            ),
            if (visuals.isNotEmpty) ...[
              const SizedBox(height: 24),
              _VisualFluffColumn(
                title: locator<TextService>()
                    .getText("uitext_secondary_upbringing"),
                entities: visuals,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VisualFluffColumn extends StatelessWidget {
  final String title;
  final List<Entity> entities;

  const _VisualFluffColumn({
    required this.title,
    required this.entities,
  });

  @override
  Widget build(BuildContext context) {
    final textService = locator<TextService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...entities.map(
          (entity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Text(
                  textService.getTextFromEntity(entity),
                  textAlign: TextAlign.justify,
                ),
                Text(
                  textService.getFluffFromEntity(entity),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UpbringingColumn extends StatelessWidget {
  final String title;
  final Entity? entity;

  const _UpbringingColumn({
    required this.title,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    if (entity == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'None selected',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final textService = locator<TextService>();
    final fluff = textService.getFluffFromEntity(entity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 12),

        Text(
          textService.getTextFromEntity(entity),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        BuffDisplay(buff: entity),

        // ───────── Divider ─────────
        if (fluff.isNotEmpty) ...[
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            color: Colors.grey.withAlpha(100),
          ),
          const SizedBox(height: 12),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                fluff,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              )),
        ],
      ],
    );
  }
}

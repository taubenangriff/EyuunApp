import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int value;
  final int max;

  const StarRating({
    super.key,
    required this.value,
    this.max = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          size: 18,
          color: Colors.orangeAccent,
        );
      }),
    );
  }
}

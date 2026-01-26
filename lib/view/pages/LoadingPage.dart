import 'dart:math';

import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuunapp/view/decoration/CircleDecoration.dart';
import 'package:eyuunapp/view/decoration/CircleProgressDecoration.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void dispose() {
    super.dispose();
    _animationController.stop();
    _animationController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('data/base/ui/bg/background.jpg'),
          fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                theme.canvasColor.withAlpha(180), BlendMode.srcOver)
        ),
      ),
      child: Center(
          child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 180,
                    decoration: CircleDecoration(
                        linePaint: Brushes.goldSparkling(stepping: 10)),
                  ),
                  Transform.rotate(
                    angle: _animation.value,
                    child: Container(
                      height: 160,
                      decoration: CircleProgressDecoration(
                          linePaint: Brushes.goldSparkling(stepping: 10),
                          segments: 20,
                          thickness: 10),
                    ),
                  ),
                  Transform.rotate(
                    angle: -_animation.value,
                    child: Container(
                      height: 120,
                      decoration: CircleProgressDecoration(
                          linePaint: Brushes.goldSparkling(stepping: 10),
                          segments: 16,
                          thickness: 10),
                    ),
                  ),
                  Image(
                      height: 86,
                      width: 86,
                      image: AssetImage('data/base/ui/eyuun_icon.png'))
                ]);
              })),
    ));
  }
}

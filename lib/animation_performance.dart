import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimationPerformance extends StatefulWidget {
  @override
  _GoodTranslate createState() => _GoodTranslate();
}

class _BadTranslate extends State<AnimationPerformance>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Placeholder(
              fallbackHeight: 100,
              key: Key('1'),
            ),
            Placeholder(
              fallbackHeight: 100,
              key: Key('2'),
            ),
            Placeholder(
              fallbackHeight: 100,
              key: Key('3'),
            ),
            Transform.translate(
              offset: Offset(-50 + 100 * _controller.value, 0),
              child: Placeholder(
                fallbackHeight: 100,
                key: Key('animated'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoodTranslate extends State<AnimationPerformance>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Placeholder(
            fallbackHeight: 100,
            key: Key('1'),
          ),
          GestureDetector(
            onTap: () {
              _controller.reverse();
            },
            child: Container(
              height: 100,
              color: Colors.redAccent,
              key: Key('2'),
            ),
          ),
          GestureDetector(
            onTap: () {
              _controller.forward();
            },
            child: Container(
              height: 100,
              color: Colors.redAccent,
              key: Key('3'),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.translate(
                offset: Offset(100 * _controller.value, 0),
                child: child,
              );
            },
            child: Placeholder(
              fallbackHeight: 100,
              key: Key('animated'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadOpacity extends State<AnimationPerformance>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Placeholder(
              fallbackHeight: 100,
              key: Key('1'),
            ),
            Placeholder(
              fallbackHeight: 100,
              key: Key('2'),
            ),
            Placeholder(
              fallbackHeight: 100,
              key: Key('3'),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Opacity(
                  opacity: _controller.value,
                  child: child,
                );
              },
              child: Placeholder(
                fallbackHeight: 100,
                key: Key('animated'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoodOpacity extends State<AnimationPerformance>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Placeholder(
              fallbackHeight: 100,
              key: Key('1'),
            ),
            Placeholder(
              fallbackHeight: 100,
              key: Key('2'),
            ),
            Placeholder(
              fallbackHeight: 100,
              key: Key('3'),
            ),
            FadeTransition(
              opacity: _controller,
              child: Placeholder(
                fallbackHeight: 100,
                key: Key('animated'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

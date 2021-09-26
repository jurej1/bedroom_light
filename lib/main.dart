import 'dart:developer';

import 'package:bedroom_light/button_painter.dart';
import 'package:bedroom_light/circle_painter.dart';
import 'package:bedroom_light/light_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hold/hold_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HoldCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedRing(),
            Positioned(
              bottom: 50,
              child: GestureDetector(
                onTapDown: (tapDownDetails) {
                  BlocProvider.of<HoldCubit>(context).pressDown();
                },
                onTapCancel: () {
                  BlocProvider.of<HoldCubit>(context).pressUp();
                },
                onTapUp: (tapUpDetails) {
                  BlocProvider.of<HoldCubit>(context).pressUp();
                },
                child: BlocBuilder<HoldCubit, bool>(
                  builder: (context, state) {
                    return CustomPaint(
                      size: Size.fromRadius(25),
                      painter: ButtonPainter(
                        isPressed: state,
                        animationValue: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IgnorePointer(
                child: BlocBuilder<HoldCubit, bool>(
                  builder: (context, state) {
                    return CustomPaint(
                      size: Size(size.width, size.height * 0.5),
                      painter: LightPainter(
                        onColor: Colors.yellow,
                        isOn: state,
                        baseColor: Colors.white,
                        strokeWidth: 3.5,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedRing extends StatefulWidget {
  const AnimatedRing({Key? key}) : super(key: key);

  @override
  _AnimatedRingState createState() => _AnimatedRingState();
}

class _AnimatedRingState extends State<AnimatedRing> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener<HoldCubit, bool>(
      listener: (context, isAnimating) {
        if (isAnimating) {
          _animationController.repeat();
        } else {
          _animationController.reset();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            size: size,
            painter: CirclePainter(
              isAnimating: _animationController.isAnimating,
              animatedValue: _animationController.value,
            ),
          );
        },
      ),
    );
  }
}

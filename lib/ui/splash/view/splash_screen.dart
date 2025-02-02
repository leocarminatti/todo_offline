import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/routes.dart';
import '../../ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(PathRoutes.todo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
          opacity: _opacity,
          child: LogoApp(),
        ),
      ),
    );
  }
}

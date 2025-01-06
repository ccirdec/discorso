import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, '/auth'),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Center(
        child: Image.asset(
          'assets/logo.gif',
          width: 132,
          height: 190,
        ),
      ),
    );
  }
}

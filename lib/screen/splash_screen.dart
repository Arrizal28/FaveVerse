import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _scaleUp = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _scaleUp = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          width: _scaleUp ? 400 : 100,
          height: _scaleUp ? 400 : 100,
          child: AnimatedOpacity(
            opacity: _scaleUp ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: Image.asset('assets/images/faveverselogodesign.png'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.asset('assets/images/faveverselogodesign.png', width: 200, height: 200),
      ),
    );
  }
}
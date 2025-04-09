import 'package:flutter/material.dart';

enum FvColors {
  blue("Blue", Color(0xFF5669FF));

  const FvColors(this.name, this.color);

  final String name;
  final Color color;
}
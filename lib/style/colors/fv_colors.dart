import 'package:flutter/material.dart';

enum FvColors {
  blueyoung("Blueyoung", Color(0xFF5669FF)),
  blue("Blue", Color(0xFF4A43EC));

  const FvColors(this.name, this.color);

  final String name;
  final Color color;
}
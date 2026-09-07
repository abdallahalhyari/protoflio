import 'package:flutter/material.dart';

class Skill {
  final String name;
  final IconData icon;
  final double level;

  const Skill({required this.name, required this.icon, required this.level})
      : assert(level >= 0 && level <= 1);
}

import 'package:flutter/material.dart';

class Skill {
  final String name;
  final IconData icon;
  final double level;
  final String category;
  final String description;
  final String provenIn;
  final List<String> tags;

  const Skill({
    required this.name,
    required this.icon,
    required this.level,
    this.category = 'Mobile Systems',
    this.description = '',
    this.provenIn = 'Production Enterprise Apps',
    this.tags = const [],
  }) : assert(level >= 0 && level <= 1);
}

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

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      icon: IconData(json['iconCodePoint'] as int, fontFamily: json['iconFontFamily'] as String? ?? 'MaterialIcons'),
      level: (json['level'] as num).toDouble(),
      category: json['category'] as String? ?? 'Mobile Systems',
      description: json['description'] as String? ?? '',
      provenIn: json['provenIn'] as String? ?? 'Production Enterprise Apps',
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'level': level,
      'category': category,
      'description': description,
      'provenIn': provenIn,
      'tags': tags,
    };
  }
}

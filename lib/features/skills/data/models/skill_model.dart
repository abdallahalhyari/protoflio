import 'package:flutter/material.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';

/// Data Transfer Object for [Skill], parsing JSON and mapping icon codepoints.
class SkillModel extends Skill {
  const SkillModel({
    required super.name,
    required super.icon,
    required super.level,
    super.category = 'Mobile Systems',
    super.description = '',
    super.provenIn = 'Production Enterprise Apps',
    super.tags = const [],
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      icon: skillIconFor(json['iconCodePoint'] as int),
      level: (json['level'] as num).toDouble(),
      category: json['category'] as String? ?? 'Mobile Systems',
      description: json['description'] as String? ?? '',
      provenIn: json['provenIn'] as String? ?? 'Production Enterprise Apps',
      tags:
          (json['tags'] as List?)?.map((e) => e as String).toList() ?? const [],
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

  /// Const icon for a skills.json code point; unknown values get a neutral fallback.
  static IconData skillIconFor(int codePoint) =>
      _skillIcons[codePoint] ?? Icons.auto_awesome_rounded;

  static const Map<int, IconData> _skillIcons = {
    62819: Icons.android_rounded,
    62830: Icons.architecture_rounded,
    63055: Icons.cloud_queue_rounded,
    63056: Icons.cloud_rounded,
    63082: Icons.contactless_rounded,
    63354: Icons.flutter_dash_rounded,
    63455: Icons.health_and_safety_rounded,
    63551: Icons.language_rounded,
    63595: Icons.local_fire_department_rounded,
    63625: Icons.lock_rounded,
    63671: Icons.merge_type_rounded,
    983244: Icons.qr_code_scanner_rounded,
    983518: Icons.storage_rounded,
    983521: Icons.storefront_rounded,
    983559: Icons.sync_rounded,
    983768: Icons.apple_rounded,
    983807: Icons.data_object_rounded,
  };
}

/// Helper mapping code points from bundled data to const IconData.
IconData skillIconFor(int codePoint) => SkillModel.skillIconFor(codePoint);

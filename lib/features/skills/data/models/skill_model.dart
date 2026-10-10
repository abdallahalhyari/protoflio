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
    final name = json['name'] as String;
    return SkillModel(
      name: name,
      icon: skillIconFor(json['iconCodePoint'] as int, name),
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

  /// Const icon for a skills.json code point with resilient name-based fallback.
  static IconData skillIconFor(int codePoint, [String? skillName]) {
    final direct = _skillIcons[codePoint];
    if (direct != null) return direct;

    if (skillName != null) {
      final normalized = skillName.toLowerCase();
      if (normalized.contains('flutter')) return Icons.flutter_dash_rounded;
      if (normalized.contains('android')) return Icons.android_rounded;
      if (normalized.contains('nfc') || normalized.contains('smart card')) {
        return Icons.contactless_rounded;
      }
      if (normalized.contains('qr') || normalized.contains('barcode')) {
        return Icons.qr_code_scanner_rounded;
      }
      if (normalized.contains('jwt') || normalized.contains('auth')) {
        return Icons.verified_user_rounded;
      }
      if (normalized.contains('crypto')) return Icons.lock_rounded;
      if (normalized.contains('clean') ||
          normalized.contains('mvvm') ||
          normalized.contains('arch')) {
        return Icons.architecture_rounded;
      }
      if (normalized.contains('offline') || normalized.contains('sync')) {
        return Icons.sync_rounded;
      }
      if (normalized.contains('rest') || normalized.contains('soap')) {
        return Icons.cloud_sync_rounded;
      }
      if (normalized.contains('firebase')) {
        return Icons.local_fire_department_rounded;
      }
      if (normalized.contains('aws') || normalized.contains('cloud')) {
        return Icons.cloud_queue_rounded;
      }
      if (normalized.contains('sql') || normalized.contains('server')) {
        return Icons.storage_rounded;
      }
      if (normalized.contains('git')) return Icons.merge_type_rounded;
      if (normalized.contains('algorithm')) return Icons.data_object_rounded;
      if (normalized.contains('health')) return Icons.health_and_safety_rounded;
      if (normalized.contains('commerce') ||
          normalized.contains('enterprise')) {
        return Icons.storefront_rounded;
      }
      if (normalized.contains('comm') || normalized.contains('multinational')) {
        return Icons.translate_rounded;
      }
      if (normalized.contains('ios') || normalized.contains('swift')) {
        return Icons.apple_rounded;
      }
    }
    return Icons.code_rounded;
  }

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
IconData skillIconFor(int codePoint, [String? skillName]) =>
    SkillModel.skillIconFor(codePoint, skillName);

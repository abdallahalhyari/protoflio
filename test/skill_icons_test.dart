import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';

void main() {
  // Release builds tree-shake icons, so skills.json can only use code points
  // mapped to a const Icons.* in skillIconFor.
  test('every skills.json icon maps to a known const icon', () {
    final data = jsonDecode(File('assets/data/skills.json').readAsStringSync())
        as List<dynamic>;
    for (final raw in data) {
      final json = raw as Map<String, dynamic>;
      final icon = skillIconFor(json['iconCodePoint'] as int);
      expect(icon.codePoint, json['iconCodePoint'], reason: '${json['name']}');
      expect(icon, isNot(Icons.auto_awesome_rounded));
    }
  });
}

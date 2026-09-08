import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HatInfo {
  final String l10nKey;
  final String heroTag;
  final String image;
  final Color color;

  const HatInfo({
    required this.l10nKey,
    required this.heroTag,
    required this.image,
    required this.color,
  });

  String get title => '$l10nKey.title'.tr();
  String get titleDesc => '$l10nKey.titleDesc'.tr();
  String get desc => '$l10nKey.desc'.tr();
}

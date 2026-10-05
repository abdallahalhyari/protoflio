import 'package:flutter/material.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';

/// Data Transfer Object for [HatInfo], handling JSON deserialization and color decoding.
class HatInfoModel extends HatInfo {
  const HatInfoModel({
    required super.title,
    required super.heroTag,
    required super.image,
    required super.color,
    required super.titleDesc,
    required super.desc,
  });

  factory HatInfoModel.fromJson(Map<String, dynamic> json) {
    return HatInfoModel(
      title: json['title'] as String,
      heroTag: json['heroTag'] as String,
      image: json['image'] as String,
      color: Color(json['colorValue'] as int),
      titleDesc: json['titleDesc'] as String,
      desc: json['desc'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'heroTag': heroTag,
      'image': image,
      'colorValue': color.toARGB32(),
      'titleDesc': titleDesc,
      'desc': desc,
    };
  }
}

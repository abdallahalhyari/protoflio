import 'package:flutter/material.dart';

class HatInfo {
  final String title;
  final String heroTag;
  final String image;
  final Color color;
  final String titleDesc;
  final String desc;

  const HatInfo({
    required this.title,
    required this.heroTag,
    required this.image,
    required this.color,
    required this.titleDesc,
    required this.desc,
  });

  factory HatInfo.fromJson(Map<String, dynamic> json) {
    return HatInfo(
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

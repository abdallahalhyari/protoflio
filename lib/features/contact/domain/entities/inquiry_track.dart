import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show IconData;

/// Pure domain entity representing an inquiry track / contact reason.
class InquiryTrack extends Equatable {
  final String title;
  final IconData icon;
  final String subject;
  final String defaultBody;

  const InquiryTrack({
    required this.title,
    required this.icon,
    required this.subject,
    required this.defaultBody,
  });

  @override
  List<Object?> get props => [title, icon, subject, defaultBody];
}

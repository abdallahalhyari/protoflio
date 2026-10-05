import 'package:flutter/material.dart' show Icons;
import 'package:profile/features/contact/domain/entities/inquiry_track.dart';

abstract class ContactLocalDataSource {
  List<InquiryTrack> getDefaultTracks();
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  const ContactLocalDataSourceImpl();

  static const List<InquiryTrack> defaultTracks = [
    InquiryTrack(
      title: 'Role Opportunity',
      icon: Icons.work_outline_rounded,
      subject: '[Role Opportunity] Senior Mobile Engineer - Abdallah Alhyari',
      defaultBody:
          'Hi Abdallah,\n\nI reviewed your portfolio and would like to discuss a Senior Mobile Engineer (Flutter) position at our company.\n\nLooking forward to scheduling an introductory conversation.',
    ),
    InquiryTrack(
      title: 'Architecture Audit',
      icon: Icons.architecture_rounded,
      subject: '[Architecture Review] Mobile Codebase Audit - Abdallah Alhyari',
      defaultBody:
          'Hi Abdallah,\n\nWe are looking for an expert architectural audit and performance profiling for our enterprise mobile codebase.\n\nPlease let us know your availability for a technical discovery call.',
    ),
    InquiryTrack(
      title: 'Production App',
      icon: Icons.bolt_rounded,
      subject: '[Project Inquiry] Enterprise Mobile System - Abdallah Alhyari',
      defaultBody:
          'Hi Abdallah,\n\nWe are planning to build a high-performance cross-platform system requiring offline-first synchronization and robust security.\n\nWe would love to explore an engagement scope.',
    ),
    InquiryTrack(
      title: 'Tech Advisory',
      icon: Icons.coffee_rounded,
      subject: '[Connect] Tech Advisory & Coffee - Abdallah Alhyari',
      defaultBody:
          'Hi Abdallah,\n\nI’d love to connect for a 20-minute chat regarding mobile engineering, smart-card integrations, and architecture.',
    ),
  ];

  @override
  List<InquiryTrack> getDefaultTracks() => defaultTracks;
}

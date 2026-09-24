import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show IconData, Icons;

class InquiryTrackInfo extends Equatable {
  final String title;
  final IconData icon;
  final String subject;
  final String defaultBody;

  const InquiryTrackInfo({
    required this.title,
    required this.icon,
    required this.subject,
    required this.defaultBody,
  });

  @override
  List<Object?> get props => [title, icon, subject, defaultBody];
}

const List<InquiryTrackInfo> kDefaultInquiryTracks = [
  InquiryTrackInfo(
    title: 'Role Opportunity',
    icon: Icons.work_outline_rounded,
    subject: '[Role Opportunity] Senior Mobile Architect - Abdallah Alhyari',
    defaultBody:
        'Hi Abdallah,\n\nI reviewed your portfolio and would like to discuss a Senior Mobile Architect / Flutter Engineering position at our company.\n\nLooking forward to scheduling an introductory conversation.',
  ),
  InquiryTrackInfo(
    title: 'Architecture Audit',
    icon: Icons.architecture_rounded,
    subject: '[Architecture Review] Mobile Codebase Audit - Abdallah Alhyari',
    defaultBody:
        'Hi Abdallah,\n\nWe are looking for an expert architectural audit and performance profiling for our enterprise mobile codebase.\n\nPlease let us know your availability for a technical discovery call.',
  ),
  InquiryTrackInfo(
    title: 'Production App',
    icon: Icons.bolt_rounded,
    subject: '[Project Inquiry] Enterprise Mobile System - Abdallah Alhyari',
    defaultBody:
        'Hi Abdallah,\n\nWe are planning to build a high-performance cross-platform system requiring offline-first synchronization and robust security.\n\nWe would love to explore an engagement scope.',
  ),
  InquiryTrackInfo(
    title: 'Tech Advisory',
    icon: Icons.coffee_rounded,
    subject: '[Connect] Tech Advisory & Coffee - Abdallah Alhyari',
    defaultBody:
        'Hi Abdallah,\n\nI’d love to connect for a 20-minute chat regarding mobile engineering, smart-card integrations, and architecture.',
  ),
];

class ContactInquiryState extends Equatable {
  final List<InquiryTrackInfo> tracks;
  final int selectedTrackIndex;
  final String name;
  final String company;
  final String body;
  final bool isCopied;

  const ContactInquiryState({
    this.tracks = kDefaultInquiryTracks,
    this.selectedTrackIndex = 0,
    this.name = '',
    this.company = '',
    required this.body,
    this.isCopied = false,
  });

  InquiryTrackInfo get currentTrack =>
      tracks[selectedTrackIndex.clamp(0, tracks.length - 1)];

  String get activeSubject => currentTrack.subject;

  String get formattedMessage {
    final buffer = StringBuffer();
    final cleanName = name.trim();
    final cleanCompany = company.trim();
    final cleanBody = body.trim();

    if (cleanName.isNotEmpty || cleanCompany.isNotEmpty) {
      buffer.writeln(
          'FROM: ${cleanName.isNotEmpty ? cleanName : 'Visitor'}${cleanCompany.isNotEmpty ? ' ($cleanCompany)' : ''}');
      buffer.writeln('---');
    }
    buffer.writeln(cleanBody);
    return buffer.toString();
  }

  ContactInquiryState copyWith({
    List<InquiryTrackInfo>? tracks,
    int? selectedTrackIndex,
    String? name,
    String? company,
    String? body,
    bool? isCopied,
  }) {
    return ContactInquiryState(
      tracks: tracks ?? this.tracks,
      selectedTrackIndex: selectedTrackIndex ?? this.selectedTrackIndex,
      name: name ?? this.name,
      company: company ?? this.company,
      body: body ?? this.body,
      isCopied: isCopied ?? this.isCopied,
    );
  }

  @override
  List<Object?> get props => [
        tracks,
        selectedTrackIndex,
        name,
        company,
        body,
        isCopied,
      ];
}

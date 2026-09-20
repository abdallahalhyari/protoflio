import 'package:flutter/material.dart';

class ArchitectureTopic {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String whyChosen;
  final List<DiagramStep> diagramSteps;
  final List<String> technicalHighlights;

  const ArchitectureTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.whyChosen,
    required this.diagramSteps,
    required this.technicalHighlights,
  });
}

class DiagramStep {
  final String layer;
  final String title;
  final String details;
  final IconData icon;
  final Color color;
  final String? telemetryPayload;
  final String? telemetryStatus;
  final String? latencyBudget;

  const DiagramStep({
    required this.layer,
    required this.title,
    required this.details,
    required this.icon,
    required this.color,
    this.telemetryPayload,
    this.telemetryStatus,
    this.latencyBudget,
  });
}

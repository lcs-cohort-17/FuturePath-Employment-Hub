import 'package:flutter/material.dart';

class Opportunity {
  final String id;
  final String title;
  final String company;
  final String companyIndustry;
  final String location;
  final String jobType;
  final List<String> skills;
  final String closingDate;
  final int positions;
  final String salaryRange;
  final bool isOpen;
  final String? duration;
  final String description;
  final List<RelatedProgramme> relatedProgrammes;
  final String logoInitials;
  final Color logoColor;

  const Opportunity({
    required this.id,
    required this.title,
    required this.company,
    required this.companyIndustry,
    required this.location,
    required this.jobType,
    required this.skills,
    required this.closingDate,
    required this.positions,
    required this.salaryRange,
    required this.isOpen,
    this.duration,
    required this.description,
    required this.relatedProgrammes,
    required this.logoInitials,
    required this.logoColor,
  });
}

class RelatedProgramme {
  final String title;
  final String duration;
  final String level;
  final bool isOpen;

  const RelatedProgramme({
    required this.title,
    required this.duration,
    required this.level,
    required this.isOpen,
  });
}

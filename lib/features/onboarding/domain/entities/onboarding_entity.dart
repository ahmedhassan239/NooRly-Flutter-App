/// Onboarding state from GET/PUT /me/onboarding.
library;

import 'package:flutter/foundation.dart';

@immutable
class OnboardingEntity {
  const OnboardingEntity({
    this.shahadaDate,
    this.goals = const [],
    this.summaryCompleted = false,
    this.currentStep = 'shahada_date',
    this.completed = false,
    this.completedAt,
    this.startDate,
    this.timezone,
    this.updatedAt,
  });

  final DateTime? shahadaDate;
  final List<String> goals;
  final bool summaryCompleted;
  final String currentStep;
  final bool completed;
  final DateTime? completedAt;
  final DateTime? startDate;
  final String? timezone;
  final DateTime? updatedAt;

  /// Backend step values.
  static const String stepShahadaDate = 'shahada_date';
  static const String stepGoals = 'goals';
  static const String stepSummary = 'summary';
  static const String stepDone = 'done';

  bool get needsShahadaDate => shahadaDate == null;
  bool get needsGoals => goals.isEmpty;
  bool get needsSummary => !summaryCompleted && !completed;
}

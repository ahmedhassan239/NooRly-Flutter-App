/// Onboarding API model (GET/PUT /me/onboarding).
library;

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';

class OnboardingModel extends OnboardingEntity {
  const OnboardingModel({
    super.shahadaDate,
    super.goals,
    super.summaryCompleted,
    super.currentStep,
    super.completed,
    super.completedAt,
    super.startDate,
    super.timezone,
    super.updatedAt,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      shahadaDate: json['shahada_date'] != null
          ? DateTime.tryParse(json['shahada_date'] as String)
          : null,
      goals: json['goals'] != null
          ? List<String>.from(json['goals'] as List)
          : [],
      summaryCompleted: json['summary_completed'] as bool? ?? false,
      currentStep: json['current_step'] as String? ?? OnboardingEntity.stepShahadaDate,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      timezone: json['timezone'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shahada_date': shahadaDate?.toIso8601String(),
      'goals': goals,
      'summary_completed': summaryCompleted,
      'current_step': currentStep,
      'completed': completed,
      'completed_at': completedAt?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'timezone': timezone,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

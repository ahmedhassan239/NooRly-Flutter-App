/// Onboarding repository interface.
library;

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  /// GET /me/onboarding - full onboarding state.
  Future<OnboardingEntity> getOnboarding();

  /// PUT /me/onboarding - partial update.
  Future<OnboardingEntity> updateOnboarding({
    String? shahadaDate,
    List<String>? goals,
    bool? summaryCompleted,
  });
}

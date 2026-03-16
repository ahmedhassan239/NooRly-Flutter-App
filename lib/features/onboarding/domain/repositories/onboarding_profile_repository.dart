/// Onboarding profile repository interface.
library;

import 'package:flutter_app/features/onboarding/domain/entities/onboarding_flow_state.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_profile_entity.dart';

abstract class OnboardingProfileRepository {
  /// GET /me/onboarding-profile — fetch saved onboarding profile.
  Future<OnboardingProfileEntity?> getOnboardingProfile();

  /// PUT /me/onboarding-profile — create or update from flow state.
  Future<OnboardingProfileEntity> saveOnboardingProfile(OnboardingFlowState flowState);
}

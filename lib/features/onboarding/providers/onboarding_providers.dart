/// Onboarding providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/onboarding/data/repositories/onboarding_profile_repository_impl.dart';
import 'package:flutter_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_profile_entity.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_flow_state.dart';
import 'package:flutter_app/features/onboarding/domain/repositories/onboarding_profile_repository.dart';
import 'package:flutter_app/features/onboarding/domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OnboardingRepositoryImpl(apiClient: apiClient);
});

final onboardingProfileRepositoryProvider = Provider<OnboardingProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OnboardingProfileRepositoryImpl(apiClient: apiClient);
});

/// Fetches the user's saved onboarding profile from the backend (GET /me/onboarding-profile).
/// Invalidated after saving profile so dashboard shows fresh data.
final onboardingProfileProvider = FutureProvider<OnboardingProfileEntity?>((ref) async {
  final repo = ref.watch(onboardingProfileRepositoryProvider);
  return repo.getOnboardingProfile();
});

/// In-memory state for the new onboarding flow (steps 2–6).
final onboardingFlowProvider =
    StateNotifierProvider<OnboardingFlowNotifier, OnboardingFlowState>((ref) {
  return OnboardingFlowNotifier();
});

class OnboardingFlowNotifier extends StateNotifier<OnboardingFlowState> {
  OnboardingFlowNotifier() : super(const OnboardingFlowState());

  void goToStep(int index) {
    state = state.copyWith(
      currentStepIndex: index.clamp(0, OnboardingFlowState.questionSteps - 1),
    );
  }

  void setDisplayName(String? value) {
    state = state.copyWith(displayName: value?.trim().isEmpty == true ? null : value?.trim());
  }

  void setEmbraceIslam(String? value) {
    state = state.copyWith(embraceIslamRange: value);
  }

  void setArabicLevel(String? value) {
    state = state.copyWith(arabicLevel: value);
  }

  void setPrayerLevel(String? value) {
    state = state.copyWith(prayerLevel: value);
  }

  void setQuranReadingLevel(String? value) {
    state = state.copyWith(quranReadingLevel: value);
  }

  void setGoals(List<String> value) {
    state = state.copyWith(goals: value);
  }

  void toggleGoal(String id) {
    final list = List<String>.from(state.goals);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(goals: list);
  }

  void setChallenges(List<String> value) {
    state = state.copyWith(challenges: value);
  }

  void toggleChallenge(String id) {
    final list = List<String>.from(state.challenges);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(challenges: list);
  }

  void setDailyTime(String? value) {
    state = state.copyWith(dailyTime: value);
  }

  void setPreferredLearningTime(String? value) {
    state = state.copyWith(preferredLearningTime: value);
  }

  void setLearningStyle(String? value) {
    state = state.copyWith(learningStyle: value);
  }

  void setReminderPreference(String? value) {
    state = state.copyWith(reminderPreference: value);
  }

  void setIslamDate(DateTime? value) {
    state = state.copyWith(islamDate: value);
  }

  void reset() {
    state = const OnboardingFlowState();
  }
}

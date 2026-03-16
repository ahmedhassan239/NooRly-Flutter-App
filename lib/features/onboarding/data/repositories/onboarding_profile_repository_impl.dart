/// Onboarding profile repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/onboarding/data/models/onboarding_profile_model.dart';
import 'package:flutter_app/features/onboarding/data/onboarding_profile_value_mapper.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_flow_state.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_profile_entity.dart';
import 'package:flutter_app/features/onboarding/domain/repositories/onboarding_profile_repository.dart';

class OnboardingProfileRepositoryImpl implements OnboardingProfileRepository {
  OnboardingProfileRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<OnboardingProfileEntity?> getOnboardingProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      OnboardingProfileEndpoints.get,
    );

    if (!response.status) {
      throw UnknownException(message: response.message);
    }

    final data = response.data;
    if (data == null) return null;

    final raw = data is Map<String, dynamic> ? data : null;
    if (raw == null || raw.isEmpty) return null;

    return OnboardingProfileModel.fromJson(raw as Map<String, dynamic>);
  }

  @override
  Future<OnboardingProfileEntity> saveOnboardingProfile(OnboardingFlowState flowState) async {
    final payload = <String, dynamic>{
      'display_name': flowState.displayName?.trim().isNotEmpty == true ? flowState.displayName : null,
      'embrace_islam_range': OnboardingProfileValueMapper.embraceIslamToApi(flowState.embraceIslamRange),
      'arabic_level': OnboardingProfileValueMapper.arabicToApi(flowState.arabicLevel),
      'prayer_level': OnboardingProfileValueMapper.prayerToApi(flowState.prayerLevel),
      'quran_reading_level': OnboardingProfileValueMapper.quranToApi(flowState.quranReadingLevel),
      'goals': flowState.goals.isEmpty ? null : OnboardingProfileValueMapper.goalsToApi(flowState.goals),
      'challenges': flowState.challenges.isEmpty ? null : OnboardingProfileValueMapper.challengesToApi(flowState.challenges),
      'daily_time': OnboardingProfileValueMapper.dailyTimeToApi(flowState.dailyTime),
      'preferred_learning_time': OnboardingProfileValueMapper.learningTimeToApi(flowState.preferredLearningTime),
      'learning_style': OnboardingProfileValueMapper.learningStyleToApi(flowState.learningStyle),
      'reminder_preference': OnboardingProfileValueMapper.reminderToApi(flowState.reminderPreference),
      'islam_date': flowState.islamDate?.toIso8601String().split('T').first,
    };

    final response = await _apiClient.put<Map<String, dynamic>>(
      OnboardingProfileEndpoints.update,
      data: payload,
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    final raw = response.data! as Map<String, dynamic>;
    return OnboardingProfileModel.fromJson(raw);
  }
}

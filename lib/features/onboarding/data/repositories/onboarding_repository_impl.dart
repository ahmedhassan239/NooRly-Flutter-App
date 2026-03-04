/// Onboarding repository implementation.
library;

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/config/endpoints.dart';
import 'package:flutter_app/core/errors/api_exception.dart';
import 'package:flutter_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:flutter_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flutter_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<OnboardingEntity> getOnboarding() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      OnboardingEndpoints.get,
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    return OnboardingModel.fromJson(response.data! as Map<String, dynamic>);
  }

  @override
  Future<OnboardingEntity> updateOnboarding({
    String? shahadaDate,
    List<String>? goals,
    bool? summaryCompleted,
  }) async {
    final payload = <String, dynamic>{};
    if (shahadaDate != null) payload['shahada_date'] = shahadaDate;
    if (goals != null) payload['goals'] = goals;
    if (summaryCompleted != null) payload['summary_completed'] = summaryCompleted;

    final response = await _apiClient.put<Map<String, dynamic>>(
      OnboardingEndpoints.update,
      data: payload.isNotEmpty ? payload : null,
    );

    if (!response.status || response.data == null) {
      throw UnknownException(message: response.message);
    }

    return OnboardingModel.fromJson(response.data! as Map<String, dynamic>);
  }
}

/// Onboarding providers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/providers/core_providers.dart';
import 'package:flutter_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_app/features/onboarding/domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OnboardingRepositoryImpl(apiClient: apiClient);
});

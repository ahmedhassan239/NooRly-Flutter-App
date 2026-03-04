import 'package:flutter_app/core/api/api_client.dart';
import 'package:flutter_app/core/api/api_response.dart';
import 'package:flutter_app/core/auth/token_storage.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([ApiClient, TokenStorage])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockApiClient mockApiClient;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockApiClient = MockApiClient();
    mockTokenStorage = MockTokenStorage();
    authRepository = AuthRepositoryImpl(
      apiClient: mockApiClient,
      tokenStorage: mockTokenStorage,
    );
  });

  group('socialLogin', () {
    const provider = 'google';
    const token = 'fake_token';
    final userModel = UserModel(id: '1', name: 'Test User', email: 'test@example.com');
    final authResponseData = {
      'status': true,
      'message': 'Success',
      'data': {
        'access_token': 'access_token',
        'refresh_token': 'refresh_token',
        'expires_at': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        'user': userModel.toJson(),
      }
    };

    test('should call ApiClient with correct parameters and save tokens', () async {
      // Arrange
      when(mockApiClient.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => ApiResponse<Map<String, dynamic>>(
            status: true,
            message: 'Success',
            data: authResponseData['data'] as Map<String, dynamic>,
          ));

      when(mockTokenStorage.saveAuthData(
        accessToken: anyNamed('accessToken'),
        refreshToken: anyNamed('refreshToken'),
        expiry: anyNamed('expiry'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async {});

      // Act
      final result = await authRepository.socialLogin(provider: provider, token: token);

      // Assert
      verify(mockApiClient.post(
        '/auth/social-login',
        data: {'provider': provider, 'token': token},
      )).called(1);

      verify(mockTokenStorage.saveAuthData(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        expiry: anyNamed('expiry'),
        userId: '1',
      )).called(1);

      expect(result.user.id, userModel.id);
    });
  });
}

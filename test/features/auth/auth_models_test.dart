import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('fromJson parses user data correctly', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'name': 'Test User',
        'avatar_url': 'https://example.com/avatar.jpg',
        'phone': '+1234567890',
        'shahada_date': '2024-01-15T00:00:00.000Z',
        'learning_goals': ['prayer', 'quran', 'arabic'],
        'email_verified': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-20T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.phone, '+1234567890');
      expect(user.shahadaDate, isNotNull);
      expect(user.learningGoals, ['prayer', 'quran', 'arabic']);
      expect(user.isEmailVerified, isTrue);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.shahadaDate, isNull);
      expect(user.learningGoals, isNull);
    });

    test('toJson serializes correctly', () {
      const user = UserModel(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        isEmailVerified: true,
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['email_verified'], isTrue);
    });

    test('toEntity converts to UserEntity', () {
      const model = UserModel(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
      );

      final entity = model.toEntity();

      expect(entity, isA<UserEntity>());
      expect(entity.id, '123');
      expect(entity.email, 'test@example.com');
      expect(entity.name, 'Test User');
    });
  });

  group('LoginRequest', () {
    test('toJson serializes correctly', () {
      const request = LoginRequest(
        email: 'test@example.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
    });
  });

  group('RegisterRequest', () {
    test('toJson serializes correctly', () {
      const request = RegisterRequest(
        email: 'test@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
        name: 'Test User',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
      expect(json['password_confirmation'], 'password123');
      expect(json['name'], 'Test User');
    });

    test('toJson excludes null name', () {
      const request = RegisterRequest(
        email: 'test@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      final json = request.toJson();

      expect(json.containsKey('name'), isFalse);
    });
  });

  group('AuthResponse', () {
    test('fromJson parses response correctly', () {
      final json = {
        'user': {
          'id': '123',
          'email': 'test@example.com',
          'name': 'Test User',
        },
        'access_token': 'access_token_value',
        'refresh_token': 'refresh_token_value',
        'expires_in': 3600,
        'token_type': 'Bearer',
      };

      final response = AuthResponse.fromJson(json);

      expect(response.user.id, '123');
      expect(response.user.email, 'test@example.com');
      expect(response.accessToken, 'access_token_value');
      expect(response.refreshToken, 'refresh_token_value');
      expect(response.expiresIn, 3600);
      expect(response.tokenType, 'Bearer');
    });

    test('expiryDateTime calculates correctly', () {
      final json = {
        'user': {'id': '123', 'email': 'test@example.com'},
        'access_token': 'token',
        'expires_in': 3600,
      };

      final response = AuthResponse.fromJson(json);
      final expiry = response.expiryDateTime;

      expect(expiry, isNotNull);
      // Should be approximately 1 hour from now
      expect(
        expiry!.difference(DateTime.now()).inMinutes,
        closeTo(60, 1),
      );
    });
  });

  group('AuthState', () {
    test('initial state is correct', () {
      const state = AuthState.initial();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.isAuthenticated, isFalse);
    });

    test('authenticated state has user', () {
      const user = UserEntity(id: '123', email: 'test@example.com');
      const state = AuthState.authenticated(user);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, user);
      expect(state.isAuthenticated, isTrue);
    });

    test('unauthenticated state is correct', () {
      const state = AuthState.unauthenticated();
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.isAuthenticated, isFalse);
    });

    test('guest state is correct', () {
      const state = AuthState.guest();
      expect(state.status, AuthStatus.guest);
      expect(state.isGuest, isTrue);
      expect(state.canAccessContent, isTrue);
    });

    test('canAccessContent is true for authenticated and guest', () {
      const authState = AuthState.authenticated(
        UserEntity(id: '123', email: 'test@example.com'),
      );
      const guestState = AuthState.guest();
      const unauthState = AuthState.unauthenticated();

      expect(authState.canAccessContent, isTrue);
      expect(guestState.canAccessContent, isTrue);
      expect(unauthState.canAccessContent, isFalse);
    });
  });
}

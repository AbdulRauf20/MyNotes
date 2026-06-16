import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('should not be initialized at first', () {
      expect(provider._isInitialized, false);
    });

    test('cannot log out if not initialized', () {
      expect(
        () => provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'should initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('create user should delegate to login function', () async {
      await provider.initialize();

      expect(
        () => provider.createUser(email: 'bad@email.com', password: 'password'),
        throwsA(TypeMatcher<UserNotFoundException>()),
      );

      expect(
        () =>
            provider.createUser(email: 'someone@bar.com', password: 'RAUFKHAN'),
        throwsA(TypeMatcher<WrongPasswordException>()),
      );

      final user = await provider.createUser(
        email: 'test@email.com',
        password: 'test',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('login user should be able to get verified', () async {
      await provider.initialize();

      await provider.createUser(email: 'test@email.com', password: 'test');

      await provider.sendEmailVerification();

      final user = provider.currentUser;

      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to logout and login again', () async {
      await provider.initialize();

      await provider.createUser(email: 'test@email.com', password: 'test');

      await provider.logOut();

      await provider.logIn(email: 'test@email.com', password: 'test');

      final user = provider.currentUser;

      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  bool _isInitialized = false;
  AuthUser? _user;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'bad@email.com') throw UserNotFoundException();
    if (password == 'RAUFKHAN') throw WrongPasswordException();
    final user = AuthUser(isEmailVerified: false);
    _user = user;
    return user;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'bad@email.com') throw UserNotFoundException();
    if (password == 'RAUFKHAN') throw WrongPasswordException();
    final user = AuthUser(isEmailVerified: false);
    _user = user;
    return user;
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    _user = AuthUser(isEmailVerified: true);
  }
}

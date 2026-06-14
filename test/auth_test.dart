import 'dart:io';

import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authencation', () {
    final provider = MockAuthProvider();
    test('should not be initialized at first', () {
      expect(provider._isInitialized, false);
    });

    test('can not log out if not inilized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedExcepation>()),
      );
    });

    test('should be able to be inilized ', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test('user should be null after iniliazation', () {
      expect(provider.currentUser, null);
    });

    test(
      'should be able to inilize in less than 2 sec',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(const Duration(seconds: 2)),
    );

    test('create user should delegate to login funtion', () async {
      final BadEmailUser = provider.createUser(
        email: 'mrrauf228@gmail.com',
        password: 'password',
      );

      expect(BadEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));
      final BadPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'RAUFKHAN',
      );
      expect(
        BadPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordException>()),
      );

      final user = await provider.createUser(
        email: 'mrrauf250@gmail.com',
        password: 'RAUFKHAN',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('login user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
  });
}

class NotInitializedExcepation implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  AuthUser? _user;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedExcepation();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedExcepation();
    if (email == 'mrrauf228@gmail.com') throw UserNotFoundException();
    if (password == 'RAUFKHAN') throw WrongPasswordException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedExcepation();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedExcepation();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}

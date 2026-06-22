import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;

  const AuthState({required this.isLoading, this.loadingText = 'Please wait a moment'});
}

class AuthStateUninilized extends AuthState {
  const AuthStateUninilized({required super.isLoading,super.loadingText});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required super.isLoading, super.loadingText, this.exception});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({required this.user}): super(isLoading: false);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  
  const AuthStateLoggedOut({required this.exception,required super.isLoading,super.loadingText});

  @override
  List<Object?> get props => [exception, isLoading];
}

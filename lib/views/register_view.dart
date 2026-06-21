import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering){
          if (state.exception is WeakPasswordException){
            await showErrorDialog(context, 'weak password');
          }else if (state.exception is EmailAlreadyInUseException){
            await showErrorDialog(context, 'email already in use');
          }else if (state.exception is InvalidEmailAuthException){
            await showErrorDialog(context, 'invalid email');
          }else if (state.exception is GenericAuthException){
            await showErrorDialog(context, 'failed to register');
          }
        }
        },
      child: Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  final userCredential = await AuthService.firebase()
                      .createUser(email: email, password: password);
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Verification email sent! Check your inbox.',
                      ),
                    ),
                  );

                  devtools.log(userCredential.toString());
                } on WeakPasswordException catch (e) {
                  await showErrorDialog(context, 'Weak password');
                } on EmailAlreadyInUseException catch (e) {
                  await showErrorDialog(context, 'Email already in use');
                } on InvalidEmailAuthException catch (e) {
                  await showErrorDialog(context, 'Invalid email');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Failed to register');
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}

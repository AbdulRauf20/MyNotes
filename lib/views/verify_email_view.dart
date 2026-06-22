import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify email")),
      body: Column(
        children: [
          const Text(
            "We have sent an email verification to your email, Please open it to verify your account",
          ),
          const Text(
            "If you havn't received a verification email, press the button below",
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                const AuthEventSendEmailVerification(),
              );
            },
            child: const Text("Send email verification"),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }
}

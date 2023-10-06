import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/auth/auth_cubit.dart';
import '../../../../services/api/api_exceptions.dart';
import '../../../../services/auth/auth_exceptions.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  static const routeName = '/authentication/email-is-not-verified';

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  var _isLoading = false;

  Future<void> _onLogout() async {
    final authBloc = context.read<AuthCubit>();
    setState(() => _isLoading = true);
    await authBloc.logout();
    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    final authBloc = context.read<AuthCubit>();

    setState(() => _isLoading = true);
    await authBloc.verifyAccountVerification();
    setState(() => _isLoading = false);
  }

  void _showErrorMessage(
    String error, {
    required ScaffoldMessengerState messenger,
  }) {
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        // When user account is deleted for example.
        if (state is AuthStateUnAuthenticated) {
          _showErrorMessage('Logging out...', messenger: messenger);
          return;
        }
        // We don't want to handle any other
        // state other than AuthStateAuthenticated
        if (state is! AuthStateAuthenticated) {
          return;
        }

        // If we didn't get any exception or error
        final exception = state.exception;
        if (exception == null) {
          return;
        }
        // If it network exception
        if (exception is NetworkRequestException) {
          _showErrorMessage('Please check your internet connection.',
              messenger: messenger);
          return;
        }
        // If it's not AuthException
        if (exception is! AuthException) {
          _showErrorMessage(
            'Unknown error: ${exception.toString()}',
            messenger: messenger,
          );
          return;
        }

        // AuthException
        switch (exception.type) {
          case AuthErrorType.accountNotVerified:
            _showErrorMessage(
              'Your account is still not verified.',
              messenger: messenger,
            );
            break;
          case AuthErrorType.tooManyAuthenticateRequests:
            _showErrorMessage(
              'Too many requests. Please try again later.',
              messenger: messenger,
            );
            break;
          case AuthErrorType.userAccountIsDisabled:
            _showErrorMessage(
              'Your account has been disabled. Please contact the support for more information.',
              messenger: messenger,
            );
            break;
          default:
            _showErrorMessage(
              'Unknown auth error: $exception',
              messenger: messenger,
            );
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email not verified'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const CircularProgressIndicator.adaptive();
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Please verifiy your emaill address in the email inbox.',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _isLoading ? null : _onLogout,
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                        ),
                        TextButton.icon(
                          onPressed: _isLoading ? null : _onRefresh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

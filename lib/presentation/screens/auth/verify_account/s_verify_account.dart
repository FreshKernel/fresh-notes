import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/auth/auth_exceptions.dart';
import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../../logic/core/api/api_exceptions.dart';
import '../../../utils/dialog/w_error_dialog.dart';
import '../../../utils/extensions/build_context_ext.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final messenger = context.messenger;

        // When user account is deleted for example.
        if (state is AuthStateUnAuthenticated) {
          messenger.showMessage(
            'Logging out...',
          );
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
          messenger.showMessage(
            'Please check your internet connection.',
            useSnackBar: false,
          );
          return;
        }
        // If it's not AuthException
        if (exception is! AuthException) {
          messenger.showMessage(
            'Unknown error: ${exception.toString()}',
            useSnackBar: false,
          );
          return;
        }

        // AuthException
        switch (exception.type) {
          case AuthErrorType.accountNotVerified:
            messenger.showMessage(
              'Your account is still not verified.',
              useSnackBar: false,
            );
            break;
          case AuthErrorType.tooManyAuthenticateRequests:
            messenger.showMessage(
              'Too many requests. Please try again later.',
              useSnackBar: false,
            );
            break;
          case AuthErrorType.userAccountIsDisabled:
            messenger.showMessage(
              'Your account has been disabled. Please contact the support for more information.',
              useSnackBar: false,
            );
            break;
          default:
            showErrorDialog(
              context: context,
              options: ErrorDialogOptions(
                message: 'Unknown auth error: $exception',
                developerError: DeveloperErrorDialog(
                  exception: exception,
                  stackTrace: StackTrace.current,
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/auth/auth_exceptions.dart';
import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../../logic/core/api/api_exceptions.dart';
import '../../../l10n/extensions/localizations.dart';
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
            context.loc.loggingOut,
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
            context.loc.pleaseCheckYourInternetConnection,
            useSnackBar: false,
          );
          return;
        }
        // If it's not AuthException
        if (exception is! AuthException) {
          messenger.showMessage(
            context.loc.unknownErrorWithMessage(exception.toString()),
            useSnackBar: false,
          );
          return;
        }

        // AuthException
        switch (exception.type) {
          case AuthErrorType.accountNotVerified:
            messenger.showMessage(
              context.loc.yourAccountIsStillNotVerified,
              useSnackBar: false,
            );
            break;
          case AuthErrorType.tooManyAuthenticateRequests:
            messenger.showMessage(
              context.loc.tooManyRequestsMsg,
              useSnackBar: false,
            );
            break;
          case AuthErrorType.userAccountIsDisabled:
            messenger.showMessage(
              context.loc.yourAccountHasBeenDisabledMessage,
              useSnackBar: false,
            );
            break;
          default:
            showErrorDialog(
              context: context,
              options: ErrorDialogOptions(
                message: context.loc
                    .authErrorUnknownWithMessage(exception.toString()),
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
          title: Text(context.loc.verifyYourEmailAddress),
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
                    Center(
                      child: Text(
                        context.loc.pleaseVerifyYourEmailAddressMessage,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _isLoading ? null : _onLogout,
                          icon: const Icon(Icons.logout),
                          label: Text(context.loc.logout),
                        ),
                        TextButton.icon(
                          onPressed: _isLoading ? null : _onRefresh,
                          icon: const Icon(Icons.refresh),
                          label: Text(context.loc.refresh),
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

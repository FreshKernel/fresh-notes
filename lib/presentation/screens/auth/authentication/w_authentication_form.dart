import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../logic/auth/auth_custom_provider.dart';
import '../../../../logic/auth/auth_exceptions.dart';
import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../../logic/connection/cubit/connection_cubit.dart';
import '../../../../logic/core/api/api_exceptions.dart';
import '../../../components/auth/w_email_field.dart';
import '../../../components/auth/w_password_field.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../../utils/dialog/w_app_dialog.dart';
import '../../../utils/dialog/w_error_dialog.dart';
import '../../../utils/extensions/build_context_ext.dart';
import 'w_forgot_password.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({super.key});

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _forgotPassword() async {
    final authBloc = context.read<AuthCubit>();
    final email = await showAppDialog<String>(
          context: context,
          builder: (context) {
            return ForgotPasswordDialog(
              initEmail: _emailController.text,
            );
          },
        ) ??
        '';
    if (email.trim().isEmpty) {
      return;
    }
    setState(() => _isLoading = true);
    await authBloc.sendForgotPasswordLink(
      email: email,
    );
    setState(() => _isLoading = false);
  }

  Future<void> _onSubmit({bool isSignUp = true}) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final isValid = _formKey.currentState?.validate() ?? false;

    final messenger = context.messenger;
    if (!isValid) {
      messenger.showMessage(
        context.loc.pleaseEnterYourData,
      );
      return;
    }
    _formKey.currentState?.save(); // Not required
    setState(() => _isLoading = true);
    await context.read<AuthCubit>().authenticateWithEmailAndPassword(
          email: email,
          password: password,
          isSignUp: isSignUp,
        );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // If the user logged in in the new state
        // then we don't want to rebuilt the widget
        // since he will navigate to new screen anyway

        if (state is! AuthStateUnAuthenticated) {
          return;
        }
        final messenger = context.messenger;

        final e = state.exception;
        if (e == null) {
          if (state.lastAction ==
              AuthStateUnAuthenticatedAction.sendResetPasswordLinkToEmail) {
            messenger.showMessage(
              context.loc.ifYourEmailIsExistsCheckYourEmailInbox,
            );
          }
          return;
        }

        var error = '${context.loc.unknownError}. ${e.toString()}';
        var isDevError = true;
        if (e is AuthException) {
          switch (e.type) {
            case AuthErrorType.userNotFound:
              error = context.loc.authErrorUserNotFound;
              isDevError = false;
              break;
            case AuthErrorType.invalidCredentials:
              error = context.loc.authErrorInvalidCredentials;
              isDevError = false;
              break;
            case AuthErrorType.weakPassword:
              error = context.loc.authErrorWeakPassword;
              isDevError = false;
              break;
            case AuthErrorType.emailAlreadyInUse:
              error = context.loc.authErrorEmailAlreadyInUse;
              isDevError = false;
              break;
            case AuthErrorType.userAccountIsDisabled:
              error = context.loc.authErrorUserAccountIsDisabled;
              isDevError = false;
              break;
            case AuthErrorType.tooManyAuthenticateRequests:
              error = context.loc.tooManyRequestsMsg;
              isDevError = false;
              break;
            default:
              error = context.loc
                  .authErrorUnknownWithMessage('${e.type}. ${e.message}.');
              break;
          }
        }

        if (e is NetworkRequestException) {
          error = context.loc.pleaseCheckYourInternetConnection;
          isDevError = false;
        }

        showErrorDialog(
          context: context,
          options: ErrorDialogOptions(
            title: context.loc.error,
            message: error,
            developerError: isDevError
                ? DeveloperErrorDialog(
                    exception: e,
                    stackTrace: StackTrace.current,
                  )
                : null,
          ),
        );
      },
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Builder(builder: (context) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  EmailTextField(
                    emailController: _emailController,
                    inputDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PasswordTextField(
                    passwordController: _passwordController,
                    inputDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.forgotPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<ConnectionCubit, ConnState>(
                    builder: (context, state) {
                      if (state is ConnStateInternetDisconnected) {
                        return Text(
                          context.loc.internetConnectionIsRequired,
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _onSubmit(isSignUp: false),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(context.loc.login),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _onSubmit,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  context.loc.register,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  context.loc.orLoginWithSocialMediaAccount,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final authBloc = context.read<AuthCubit>();
                                  setState(() => _isLoading = true);
                                  await authBloc.authenticateWithCustomProvider(
                                    AuthProvider.google,
                                  );
                                  setState(() => _isLoading = false);
                                },
                                icon: SvgPicture.asset(
                                  Assets.svg.googleIcon.path,
                                  semanticsLabel: 'Google',
                                  height: 20,
                                ),
                                label: Text(context.loc.google),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final authBloc = context.read<AuthCubit>();
                                  setState(() => _isLoading = true);
                                  await authBloc.authenticateWithCustomProvider(
                                    AuthProvider.apple,
                                  );
                                  setState(() => _isLoading = false);
                                },
                                icon: const Icon(Icons.apple),
                                label: Text(context.loc.apple),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}

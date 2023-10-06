import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/auth/auth_exceptions.dart';
import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../../logic/core/api/api_exceptions.dart';
import '../../../components/auth/w_email_field.dart';
import '../../../components/auth/w_password_field.dart';
import '../../../utils/dialog/w_app_dialog.dart';
import 'w_forgot_password.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  static const routeName = '/authentication';

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
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
        final messenger = ScaffoldMessenger.of(context);

        final e = state.exception;
        if (e == null) {
          if (state.lastAction ==
              AuthStateUnAuthenticatedAction.sendResetPasswordLinkToEmail) {
            messenger.showSnackBar(const SnackBar(
              content: Text('Please check your email inbox'),
            ));
          }
          return;
        }
        messenger.clearSnackBars();

        var error =
            'Unknown error. Please contact support with ${e.toString()}';
        if (e is AuthException) {
          switch (e.type) {
            case AuthErrorType.invalidCredentials:
              error = 'Invalid password or email address.';
              break;
            case AuthErrorType.weakPassword:
              error = 'Please enter strong password.';
              break;
            case AuthErrorType.emailAlreadyInUse:
              error = 'Please try using different email address.';
              break;
            case AuthErrorType.userAccountIsDisabled:
              error =
                  'Your account is disabled. Please contact with the support for more information.';
              break;
            case AuthErrorType.tooManyAuthenticateRequests:
              error =
                  'You have sent too many requests. Please try again later.';
              break;
            default:
              error =
                  'Unknown auth error of type = ${e.type} and message = ${e.message}';
              break;
          }
        }

        if (e is NetworkRequestException) {
          error = 'Please check your internet connection.';
        }

        messenger.showSnackBar(SnackBar(
          content: Text(error),
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Center(
              child: Builder(builder: (context) {
                if (_isLoading) {
                  return const CircularProgressIndicator.adaptive();
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FlutterLogo(size: 200),
                      const SizedBox(height: 20),
                      EmailTextField(
                        emailController: _emailController,
                        inputDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      PasswordTextField(
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _onSubmit(isSignUp: false),
                            child: const Text('Login'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _onSubmit,
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _forgotPassword,
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
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

    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    if (!isValid) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter your data.'),
        ),
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
}

import 'package:flutter/material.dart';
import 'package:my_notes/components/auth/w_email_field.dart';
import 'package:my_notes/components/auth/w_password_field.dart';
import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/screens/auth/email_not_verified/s_email_not_verified.dart';
import 'package:my_notes/screens/dashboard/s_dashboard.dart';
import 'package:my_notes/services/api/api_exceptions.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/auth/auth_user.dart';

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
    return Scaffold(
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
                    EmailTextField(emailController: _emailController),
                    const SizedBox(height: 14),
                    PasswordTextField(
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _onSubmit,
                          child: const Text('Login'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => _onSubmit(isLogin: false),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit({bool isLogin = true}) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final isValid = _formKey.currentState?.validate() ?? false;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    messenger.clearSnackBars();
    if (!isValid) {
      // messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter your data.'),
        ),
      );
      return;
    }
    try {
      setState(() => _isLoading = true);
      final authService = AuthService.getInstance();
      final AuthUser user = isLogin
          ? await authService.signInWithEmailAndPassword(
              email: email,
              password: password,
            )
          : await authService.signUpWithEmailAndPassword(
              email: email,
              password: password,
            );
      final isEmailVerified = user.isEmailVerified;
      if (!isEmailVerified) {
        await authService.sendEmailVerification();
        navigator.pushReplacement(MaterialPageRoute(
          settings:
              const RouteSettings(name: EmailIsNotVerifiedScreen.routeName),
          builder: (context) {
            return const EmailIsNotVerifiedScreen();
          },
        ));
        return;
      }
      navigator.pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: DashboardScreen.routeName),
        builder: (context) {
          return const DashboardScreen();
        },
      ));
    } on AuthException catch (e, stackTrace) {
      setState(() => _isLoading = false);
      AppLogger.error(
        e.toString(),
        stackTrace: stackTrace,
      );
      var error =
          'Unknown auth error. Please contact support with ${e.message}';
      if (e is InvalidCredentialsAuthException) {
        error = 'Invalid password or email address.';
      } else if (e is WeakPasswordAuthException) {
        error = 'Please enter strong password.';
      } else if (e is NetworkRequestException) {
        error = 'Please check your internet connection.';
      } else if (e is EmailAlreadyInUseAuthException) {
        error = 'Please try using different email address.';
      } else if (e is UserDisabledAuthException) {
        error =
            'Your account is disabled. Please contact with the support for more information.';
      }
      // switch (e) {
      //   case 'INVALID_LOGIN_CREDENTIALS':
      //     error = 'Invalid password or email address.';
      //     break;
      //   case 'weak-password':
      //     error = 'Please enter strong password.';
      //     break;
      //   case 'network-request-failed':
      //     error = 'Please check your internet connection.';
      //     break;
      //   case 'email-already-in-use':
      //     error = 'Please try using different email address.';
      //     break;
      //   case 'user-disabled':
      //     error =
      //         'Your account is disabled. Please contact with the support for more information.';
      //     break;
      // }
      messenger.showSnackBar(SnackBar(
        content: Text(error),
      ));
    } catch (e) {
      setState(() => _isLoading = false);
      if (e is NetworkRequestException) {
        messenger.showSnackBar(SnackBar(
          content: Text('Network exception: ${e.message}'),
        ));
        return;
      }
      messenger.showSnackBar(SnackBar(
        content: Text('Unknown error: ${e.toString()}'),
      ));
    }
  }
}

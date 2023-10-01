import 'package:flutter/material.dart';

import '../../../components/auth/w_email_field.dart';
import '../../../components/auth/w_password_field.dart';
import '../../../core/log/logger.dart';
import '../../../services/api/api_exceptions.dart';
import '../../../services/auth/auth_exceptions.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/data/notes/s_notes_data.dart';
import '../../dashboard/s_dashboard.dart';
import '../email_not_verified/s_email_not_verified.dart';

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
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter your data.'),
        ),
      );
      return;
    }
    _formKey.currentState?.save(); // Not required
    try {
      setState(() => _isLoading = true);
      final authService = AuthService.getInstance();
      final user = isLogin
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
      await NotesDataService.getInstance().syncCloudToLocal();
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
        default:
          error =
              'Unknown error of type = ${e.type} and message = ${e.message}';
          break;
      }

      messenger.showSnackBar(SnackBar(
        content: Text(error),
      ));
    } on NetworkRequestException {
      messenger.showSnackBar(const SnackBar(
        content: Text('Please check your internet connection.'),
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

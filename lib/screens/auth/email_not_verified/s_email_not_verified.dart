import 'package:flutter/material.dart';
import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/screens/auth/authentication/s_authentication.dart';
import 'package:my_notes/screens/dashboard/s_dashboard.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';

class EmailIsNotVerifiedScreen extends StatefulWidget {
  const EmailIsNotVerifiedScreen({super.key});

  static const routeName = '/authentication/email-is-not-verified';

  @override
  State<EmailIsNotVerifiedScreen> createState() =>
      _EmailIsNotVerifiedScreenState();
}

class _EmailIsNotVerifiedScreenState extends State<EmailIsNotVerifiedScreen> {
  var _isLoading = false;

  Future<void> _onLogout() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await AuthService.getInstance().logout();
      navigator.pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: AuthenticationScreen.routeName),
        builder: (context) {
          return const AuthenticationScreen();
        },
      ));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Unknown error while logout ${e.toString()} of type ${e.runtimeType}.',
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    messenger.clearSnackBars();

    final authService = AuthService.getInstance();

    try {
      final reloadedUser = await authService.reloadTheCurrentUser();
      if (reloadedUser == null) {
        messenger.showSnackBar(const SnackBar(content: Text('Logging out...')));
        _backToAuthenticationScreen(navigator);
        return;
      }

      if (!reloadedUser.isEmailVerified) {
        messenger.showSnackBar(const SnackBar(
            content: Text('Email address is still not verified.')));
        return;
      }

      navigator.pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: DashboardScreen.routeName),
          builder: (context) {
            return const DashboardScreen();
          },
        ),
      );
    } on AuthException catch (e) {
      if (e.type == AuthErrorType.userAccountIsDisabled) {
        messenger.showSnackBar(const SnackBar(
          content: Text('Your account has been disabled by an admin...'),
        ));
        _backToAuthenticationScreen(navigator);
        return;
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: type = ${e.type}, message = \n ${e.message}'),
        ),
      );
    } catch (e, stacktrace) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Unknown error while logout ${e.toString()} of type ${e.runtimeType}.',
          ),
        ),
      );
      AppLogger.error(
        e.toString(),
        stackTrace: stacktrace,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _backToAuthenticationScreen(NavigatorState navigator) {
    navigator.pushReplacement(MaterialPageRoute(
      settings: const RouteSettings(name: AuthenticationScreen.routeName),
      builder: (context) {
        return const AuthenticationScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email not verified'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : SingleChildScrollView(
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
                          onPressed: _onLogout,
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                        ),
                        TextButton.icon(
                          onPressed: _onRefresh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

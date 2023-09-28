import 'package:flutter/material.dart';
import 'package:my_notes/screens/auth/authentication/s_authentication.dart';
import 'package:my_notes/screens/dashboard/s_dashboard.dart';
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

    try {
      final user = AuthService.getInstance().currentUser;
      if (user == null) {
        messenger.showSnackBar(const SnackBar(content: Text('Logging out...')));
        navigator.pushReplacement(MaterialPageRoute(
          settings: const RouteSettings(name: AuthenticationScreen.routeName),
          builder: (context) {
            return const AuthenticationScreen();
          },
        ));
        return;
      }

      if (!user.isEmailVerified) {
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

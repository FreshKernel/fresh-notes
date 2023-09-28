import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';

import '../auth/authentication/s_authentication.dart';

class LogoutIconButton extends StatefulWidget {
  const LogoutIconButton({super.key});

  @override
  State<LogoutIconButton> createState() => _LogoutIconButtonState();
}

class _LogoutIconButtonState extends State<LogoutIconButton> {
  var _isLoading = false;

  Future<void> _onLogout() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final logoutConfirmed = await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: const Text('Sign out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!logoutConfirmed) {
      return;
    }

    try {
      setState(() => _isLoading = true);
      await AuthService.getInstance().logout();
      navigator.pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(
          name: AuthenticationScreen.routeName,
        ),
        builder: (context) {
          return const AuthenticationScreen();
        },
      ));
    } catch (e) {
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Unknown error while logout ${e.toString()} of type ${e.runtimeType}.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      onPressed: _isLoading ? null : _onLogout,
      icon: const Icon(Icons.logout),
    );
  }
}

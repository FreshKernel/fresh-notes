import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';

import '../../utils/ui/dialog/w_yes_cancel_dialog.dart';
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
    final logoutConfirmed = await showYesCancelDialog(
      context: context,
      options: const YesOrCancelDialogOptions(
        title: 'Sign out',
        message: 'Are you sure you want to sign out?',
        yesLabel: 'Logout',
      ),
    );

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

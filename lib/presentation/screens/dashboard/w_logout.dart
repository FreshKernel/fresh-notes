import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/auth/auth_cubit.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';

class LogoutIconButton extends StatefulWidget {
  const LogoutIconButton({super.key});

  @override
  State<LogoutIconButton> createState() => _LogoutIconButtonState();
}

class _LogoutIconButtonState extends State<LogoutIconButton> {
  var _isLoading = false;

  Future<void> _onLogout() async {
    final authBloc = context.read<AuthCubit>();
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

    authBloc.logout();
    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is! AuthStateAuthenticated) {
          return;
        }
        final e = state.exception;
        if (e == null) {
          return;
        }
        setState(() => _isLoading = false);
        final messenger = ScaffoldMessenger.of(context);

        messenger.showSnackBar(SnackBar(
          content: Text('Unknown error: ${e.toString()}'),
        ));
      },
      child: IconButton(
        tooltip: 'Logout',
        onPressed: _isLoading ? null : _onLogout,
        icon: const Icon(Icons.logout),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/auth/cubit/auth_cubit.dart';
import '../../l10n/extensions/localizations.dart';
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
    final logoutConfirmed = await showOkCancelDialog(
      context: context,
      options: OkOrCancelDialogOptions(
        title: context.loc.signOut,
        message: context.loc.signOutDesc,
        yesLabel: context.loc.logout,
      ),
    );

    if (!logoutConfirmed) {
      return;
    }

    setState(() => _isLoading = true);
    await authBloc.logout();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return IconButton(
          tooltip: context.loc.signOut,
          onPressed: _isLoading
              ? null
              : (state is AuthStateAuthenticated ? _onLogout : null),
          icon: const Icon(Icons.logout),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/auth/cubit/auth_cubit.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/dialog/w_error_dialog.dart';
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
      options: YesOrCancelDialogOptions(
        title: context.loc.signOut,
        message: context.loc.signOutDesc,
        yesLabel: context.loc.logout,
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

        showErrorDialog(
          context: context,
          options: ErrorDialogOptions(
            message: context.loc.unknownErrorWithMessage(e.toString()),
            developerError: null,
          ),
        );
      },
      child: IconButton(
        tooltip: context.loc.signOut,
        onPressed: _isLoading ? null : _onLogout,
        icon: const Icon(Icons.logout),
      ),
    );
  }
}

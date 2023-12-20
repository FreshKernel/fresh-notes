import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../logic/auth/cubit/auth_cubit.dart';
import '../dashboard/s_dashboard.dart';
import 'authentication/s_authentication.dart';
import 'profile/s_profile.dart';
import 'verify_account/s_verify_account.dart';

/// A widget that uses authentication screen based on the state
class DynamicAuthWidget extends StatelessWidget {
  const DynamicAuthWidget({super.key});

  Widget _getScreenByAuthState(AuthState state) {
    switch (state) {
      case AuthStateAuthenticated():
        if (state.user.isEmailVerified) {
          if (state.user.data.hasUserData) {
            return const DashboardScreen();
          }
          return const ProfileScreen();
        }
        return const VerifyAccountScreen();
      case AuthStateUnAuthenticated():
        return const AuthenticationScreen();
    }
  }

  static const routeName = '/authentication';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is! AuthStateAuthenticated) {
          return;
        }
        if (!state.user.isEmailVerified || !state.user.data.hasUserData) {
          return;
        }
        if (context.canPop()) {
          context.pop();
        }
      },
      builder: (context, state) {
        final screen = _getScreenByAuthState(state);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 330),
          transitionBuilder: (child, animation) {
            // This animation is from flutter.dev example
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: screen,
        );
      },
    );
  }
}

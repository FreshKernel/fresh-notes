import 'package:flutter/material.dart'
    show Brightness, MaterialApp, ThemeData, VisualDensity;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/log/logger.dart';
import '../logic/auth/cubit/auth_cubit.dart';
import '../logic/connection/cubit/connection_cubit.dart';
import '../logic/note/cubit/note_cubit.dart';
import '../logic/settings/cubit/settings_cubit.dart';
import '../presentation/l10n/extensions/localizations.dart';
import '../presentation/screens/app_router.dart';
import '../presentation/screens/auth/authentication/s_authentication.dart';
import '../presentation/screens/auth/profile/s_save_profile.dart';
import '../presentation/screens/auth/verify_account/s_verify_account.dart';
import '../presentation/screens/dashboard/s_dashboard.dart';
import '../presentation/screens/onboarding/s_onboarding.dart';
import '../presentation/theme/color_schemes.g.dart';
import '../presentation/utils/extensions/app_theme_mode_ext.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => ConnectionCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => NoteCubit(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: SettingsCubit.buildWhen,
        builder: (context, state) {
          AppLogger.log('Building the MyApp() widget...');
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            locale: state.appLanguague == AppLanguague.system
                ? null
                : Locale(state.appLanguague.name),
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: state.themeSystem == AppThemeSystem.material3,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: state.themeSystem == AppThemeSystem.material3,
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: darkColorScheme,
            ),
            themeMode: state.themeMode.toMaterialThemeMode(
              darkDuringDayInAutoMode: state.darkDuringDayInAutoMode,
            ),
            // home: state.openOnBoardingScreen
            //     ? const OnBoardingScreen()
            //     : const MyHomeWidget(),
            // onGenerateRoute: AppRouter.onGenerateRoute,
            // onUnknownRoute: AppRouter.onUnknownRoute,
            builder: (context, child) {
              if (state.openOnBoardingScreen) {
                return const OnBoardingScreen();
              }
              return child ?? (throw ArgumentError('Child should not be null'));
            },
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) {
              return context.loc.appName;
            },
          );
        },
      ),
    );
  }
}

class MyHomeWidget extends StatelessWidget {
  const MyHomeWidget({super.key});

  static const routeName = '/';

  Widget _getScreenByAuthState(AuthState state) {
    switch (state) {
      case AuthStateAuthenticated():
        if (state.user.isEmailVerified) {
          if (state.user.data.hasUserData) {
            return const DashboardScreen();
          }
          return const SaveProfileScreen();
        }
        return const VerifyAccountScreen();
      case AuthStateUnAuthenticated():
        return const AuthenticationScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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

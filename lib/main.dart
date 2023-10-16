import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/log/logger.dart';
import 'core/start/app_startup.dart';
import 'logic/auth/cubit/auth_cubit.dart';
import 'logic/connection/cubit/connection_cubit.dart';
import 'logic/settings/cubit/settings_cubit.dart';
import 'presentation/screens/app_router.dart';
import 'presentation/screens/auth/authentication/s_authentication.dart';
import 'presentation/screens/auth/profile/s_save_profile.dart';
import 'presentation/screens/auth/verify_account/s_verify_account.dart';
import 'presentation/screens/dashboard/s_dashboard.dart';
import 'presentation/theme/color_schemes.g.dart';
import 'presentation/utils/extensions/app_theme_mode.dart';
import 'presentation/utils/extensions/build_context_extensions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await AppStartup.getInstance().initialize();
  runApp(const MyApp());
}

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
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) {
          // Rebuild the whole app only if the themeMode
          // darkDuringDayInAutoMode or appLanguague changes

          return previous.themeMode != current.themeMode ||
              previous.darkDuringDayInAutoMode !=
                  current.darkDuringDayInAutoMode ||
              previous.appLanguague != current.appLanguague;
        },
        builder: (context, state) {
          AppLogger.log('Building the MyApp() widget...');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.appLanguague == AppLanguague.system
                ? null
                : Locale(state.appLanguague.name),
            title: 'Fresh notes',
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: darkColorScheme,
            ),
            themeMode: state.themeMode.toMaterialThemeMode(
              darkDuringDayInAutoMode: state.darkDuringDayInAutoMode,
            ),
            initialRoute: MyHomeWidget.routeName,
            onGenerateRoute: AppRouter.onGenerateRoute,
            onUnknownRoute: AppRouter.onUnknownRoute,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) {
              return context.loc.app_name;
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

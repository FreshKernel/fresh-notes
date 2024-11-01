import 'package:flutter/material.dart'
    show Brightness, MaterialApp, ThemeData, VisualDensity;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../core/log/logger.dart';
import '../data/core/cloud/storage/s_cloud_storage.dart';
import '../data/core/local/storage/s_local_storage.dart';
import '../data/note_folder/local/note_local_folder.dart';
import '../data/notes/cloud/s_cloud_notes.dart';
import '../data/notes/local/s_local_notes.dart';
import '../logic/auth/auth_service.dart';
import '../logic/auth/cubit/auth_cubit.dart';
import '../logic/connection/cubit/connection_cubit.dart';
import '../logic/note/cubit/note_cubit.dart';
import '../logic/note_folder/cubit/note_folder_cubit.dart';
import '../logic/settings/cubit/settings_cubit.dart';
import '../logic/settings/cubit/settings_data.dart';
import '../presentation/l10n/extensions/localizations.dart';
import '../presentation/screens/app_router.dart';
import '../presentation/screens/dashboard/s_dashboard.dart';
import '../presentation/screens/onboarding/s_onboarding.dart';
import '../presentation/theme/color_schemes.g.dart';
import '../presentation/utils/extensions/settings_data_exts.dart';

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
          create: (context) => NoteCubit(
            cloudNotesService: CloudNotesService.getInstance(),
            localNotesService: LocalNotesService.getInstance(),
            localStorageService: LocalStorageService.getInstance(),
            cloudStorageService: CloudStorageService.getInstance(),
            authService: AuthService.getInstance(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            authService: AuthService.getInstance(),
            noteCubit: context.read<NoteCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => NoteFolderCubit(
            noteFoldersService: LocalNoteFolderImpl(),
          ),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode ||
            previous.darkDuringDayInAutoMode !=
                current.darkDuringDayInAutoMode ||
            previous.appLanguague != current.appLanguague ||
            previous.themeSystem != current.themeSystem ||
            previous.openOnBoardingScreen != current.openOnBoardingScreen,
        builder: (context, state) {
          AppLogger.log('Building the App widget...');
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
            builder: (context, child) {
              if (state.openOnBoardingScreen) {
                return const OnBoardingScreen();
              }
              return child ?? (throw ArgumentError('Child should not be null'));
            },
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) => context.loc.appName,
          );
        },
      ),
    );
  }
}

class MyHomeWidget extends StatelessWidget {
  const MyHomeWidget({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}

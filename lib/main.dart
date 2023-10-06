import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/start/app_startup.dart';
import 'logic/auth/cubit/auth_cubit.dart';
import 'presentation/screens/auth/authentication/s_authentication.dart';
import 'presentation/screens/auth/verify_account/s_verify_account.dart';
import 'presentation/screens/dashboard/s_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fresh notes',
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const _HomeWidget(),
      ),
    );
  }
}

class _HomeWidget extends StatefulWidget {
  const _HomeWidget();

  @override
  State<_HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<_HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        Widget screen;

        switch (state) {
          case AuthStateAuthenticated():
            if (state.user.isEmailVerified) {
              screen = const DashboardScreen();
            } else {
              screen = const VerifyAccountScreen();
            }
            break;
          case AuthStateUnAuthenticated():
            screen = const AuthenticationScreen();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 330),
          transitionBuilder: (child, animation) {
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

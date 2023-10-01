import 'package:flutter/material.dart';
import 'core/start/app_startup.dart';
import 'screens/auth/authentication/s_authentication.dart';
import 'screens/auth/email_not_verified/s_email_not_verified.dart';
import 'screens/dashboard/s_dashboard.dart';
import 'services/auth/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppStartup.getInstance().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) {
          final user = AuthService.getInstance().currentUser;
          if (user == null) {
            return const AuthenticationScreen();
          }
          if (!user.isEmailVerified) {
            return const EmailIsNotVerifiedScreen();
          }
          return const DashboardScreen();
        },
      ),
    );
  }
}

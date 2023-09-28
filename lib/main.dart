import 'package:flutter/material.dart';
import 'package:my_notes/core/start/app_startup.dart';
import 'package:my_notes/screens/auth/authentication/s_authentication.dart';
import 'package:my_notes/screens/auth/email_not_verified/s_email_not_verified.dart';
import 'package:my_notes/screens/dashboard/s_dashboard.dart';
import 'package:my_notes/services/auth/auth_service.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) {
          final user = AuthService.getInstance().currentUser;
          if (user == null) {
            return const AuthenticationScreen();
          } else if (!user.isEmailVerified) {
            return const EmailIsNotVerifiedScreen();
          } else {
            return const DashboardScreen();
          }
        },
      ),
    );
  }
}

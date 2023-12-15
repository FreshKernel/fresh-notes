import 'package:flutter/material.dart';

import '../../../components/others/w_app_logo.dart';
import '../../../l10n/extensions/localizations.dart';
import 'w_authentication_form.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  static const routeName = '/authentication';

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.loginScreen),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppLogo(
                size: 250,
              ),
              const SizedBox(height: 16),
              Text(
                context.loc.welcomeAgain,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                context.loc.welcomeAgainDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 550,
                child: AuthenticationForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

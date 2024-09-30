import 'package:flutter/material.dart';

import '../../l10n/extensions/localizations.dart';
import 'w_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.settings),
      ),
      body: const SafeArea(
        child: SettingsContent(),
      ),
    );
  }
}

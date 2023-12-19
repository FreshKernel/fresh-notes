import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/constants/urls_constants.dart';
import '../../../../gen/pubspec.dart' as pubspec;
import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../components/others/w_app_logo.dart';
import '../../../l10n/extensions/localizations.dart';
import '../w_settings_section.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({required this.state, super.key});

  final SettingsState state;

  IconData get icon {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => Icons.android,
      TargetPlatform.fuchsia => Icons.info,
      TargetPlatform.linux => Icons.info,
      TargetPlatform.iOS => Icons.apple,
      TargetPlatform.macOS => Icons.apple,
      TargetPlatform.windows => Icons.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.about,
      tiles: [
        AboutListTile(
          icon: Icon(icon),
          aboutBoxChildren: [
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => launchUrl(
                Uri.parse(UrlConstants.privacyPolicy),
              ),
              child: Text(
                context.loc.privacyPolicy,
              ),
            ),
          ],
          applicationIcon: const AppCircleLogo(),
          applicationLegalese: 'MIT',
          applicationVersion:
              'v${pubspec.appVersion} (${pubspec.appBuildNumber})',
        ),
      ],
    );
  }
}

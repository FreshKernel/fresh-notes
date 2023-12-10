import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/settings/cubit/settings_data.dart';
import '../../l10n/extensions/localizations.dart';

class SelectThemeModeDialog extends StatefulWidget {
  const SelectThemeModeDialog({required this.themeMode, super.key});

  final AppThemeMode themeMode;

  @override
  State<SelectThemeModeDialog> createState() => _SelectThemeModeDialogState();
}

class _SelectThemeModeDialogState extends State<SelectThemeModeDialog> {
  Widget getItemByThemeMode(AppThemeMode themeMode) {
    final (label, desc, iconData) = switch (themeMode) {
      AppThemeMode.dark => (
          context.loc.dark,
          context.loc.themeModeDarkDesc,
          Icons.nightlight_round,
        ),
      AppThemeMode.light => (
          context.loc.light,
          context.loc.themeModeLightDesc,
          Icons.wb_sunny,
        ),
      AppThemeMode.system => (
          context.loc.system,
          context.loc.themeModeSystemDesc,
          Icons.settings,
        ),
      AppThemeMode.auto => (
          context.loc.auto,
          context.loc.themeModeAutoDesc,
          Icons.autorenew,
        ),
      AppThemeMode.random => (
          context.loc.random,
          context.loc.themeModeRandomDesc,
          Icons.shuffle,
        ),
    };
    return ListTile(
      title: Text(label),
      subtitle: Text(desc),
      leading: Icon(iconData),
      trailing: Visibility(
        visible: themeMode == widget.themeMode,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedOpacity(
          opacity: themeMode == widget.themeMode ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: const Icon(
            Icons.check_box_rounded,
            color: Colors.green,
          ),
        ),
      ),
      onTap: () {
        final settingsBloc = context.read<SettingsCubit>();
        settingsBloc.updateSettings(
          settingsBloc.state.copyWith(themeMode: themeMode),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...AppThemeMode.values.map(
              getItemByThemeMode,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';

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
          'Dark',
          'If you want to always use dark mode.',
          Icons.nightlight_round,
        ),
      AppThemeMode.light => (
          'Light',
          'If you want to always use light mode.',
          Icons.wb_sunny,
        ),
      AppThemeMode.system => (
          'System',
          'If you want to let the system decide that for you.',
          Icons.settings,
        ),
      AppThemeMode.auto => (
          'Auto',
          'If you want us to decide this for you based on the time.',
          Icons.autorenew,
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

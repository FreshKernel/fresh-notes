import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CheckboxListTile.adaptive(
                    value: state.confirmDeleteNote,
                    onChanged: (newValue) {
                      context.read<SettingsCubit>().updateSettings(
                            state.copyWith(confirmDeleteNote: newValue!),
                          );
                    },
                    title: const Text('Confirm delete note'),
                    subtitle: const Text('Do you wish to delete the note?'),
                    secondary: const Icon(Icons.delete),
                  ),
                  CheckboxListTile.adaptive(
                    value: state.syncWithCloudDefaultValue,
                    onChanged: (newValue) {
                      context.read<SettingsCubit>().updateSettings(
                            state.copyWith(
                                syncWithCloudDefaultValue: newValue!),
                          );
                    },
                    title: const Text('Sync with cloud by default'),
                    subtitle: const Text(
                      'When you create a new note for example '
                      'should we sync sync it with cloud by default??',
                    ),
                    secondary: const Icon(Icons.cloud),
                  ),
                  CheckboxListTile.adaptive(
                    value: state.themeMode == AppThemeMode.dark,
                    onChanged: (newValue) {
                      context.read<SettingsCubit>().updateSettings(
                            state.copyWith(
                              themeMode: newValue!
                                  ? AppThemeMode.dark
                                  : AppThemeMode.light,
                            ),
                          );
                    },
                    title: const Text('Dark mode'),
                    subtitle: const Text('Do you wish to dark mode?'),
                    secondary: const Icon(Icons.dark_mode),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

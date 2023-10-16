import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../utils/extensions/build_context_extensions.dart';
import 'w_select_theme_mode.dart';

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
                  ListTile(
                    title: const Text('Theme mode'),
                    subtitle: const Text(
                      'Choose whatever if you want dark mode '
                      'or light mode or system',
                    ),
                    leading:
                        Icon(context.isDark ? Icons.nightlight : Icons.sunny),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        constraints: const BoxConstraints(maxWidth: 640),
                        builder: (context) {
                          // This is a different widget and since the show
                          // ModalBottomSheet() doesn't rebuild when the parent
                          // widget rebuilt, then we need to it ourseleves
                          return BlocBuilder<SettingsCubit, SettingsState>(
                            buildWhen: (previous, current) {
                              return previous.themeMode != current.themeMode;
                            },
                            builder: (context, state) {
                              return SelectThemeModeDialog(
                                themeMode: state.themeMode,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  Visibility(
                    visible: state.themeMode == AppThemeMode.auto,
                    maintainState: true,
                    maintainAnimation: true,
                    child: AnimatedOpacity(
                      opacity: state.themeMode == AppThemeMode.auto ? 1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: CheckboxListTile.adaptive(
                        value: state.darkDuringDayInAutoMode,
                        onChanged: (newValue) {
                          context.read<SettingsCubit>().updateSettings(
                                state.copyWith(
                                  darkDuringDayInAutoMode: newValue,
                                ),
                              );
                        },
                        title: const Text('Dark mode during day'),
                        subtitle: const Text(
                          'Since you choose theme mode auto then you can set '
                          'if you want dark theme during day or the opposite.',
                        ),
                        secondary: const Icon(Icons.dark_mode),
                      ),
                    ),
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

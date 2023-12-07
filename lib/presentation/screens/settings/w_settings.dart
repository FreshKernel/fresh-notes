import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../utils/extensions/build_context_ext.dart';
import 'w_select_theme_mode.dart';
import 'w_settings_section.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Column(
            children: [
              _GeneralSection(state: state),
              SettingsSection(
                title: 'Notes',
                tiles: [
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
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  final settingsBloc = context.read<SettingsCubit>();
                  settingsBloc.clear();
                },
                child: const Text('Clear'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GeneralSection extends StatelessWidget {
  const _GeneralSection({
    required this.state,
    // ignore: unused_element
    super.key,
  });

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'General',
      tiles: [
        ListTile(
          title: const Text('App languague'),
          subtitle: const Text('Which languague you want to use in the app?'),
          leading: const Icon(Icons.language),
          trailing: DropdownButton<AppLanguague>(
            value: state.appLanguague,
            items: AppLanguague.values
                .map(
                  (e) => DropdownMenuItem<AppLanguague>(
                    value: e,
                    child: Text(e.valueName),
                  ),
                )
                .toList(),
            onChanged: (newLanguague) {
              if (newLanguague == null) {
                return;
              }
              context.read<SettingsCubit>().updateAppLanguague(newLanguague);
            },
          ),
        ),
        ListTile(
          title: const Text('Theme mode'),
          subtitle: const Text(
            'Choose whatever if you want dark mode '
            'or light mode or system',
          ),
          leading: Icon(context.isDark ? Icons.nightlight : Icons.sunny),
          onTap: () => showModalBottomSheet(
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
          ),
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
        if (context.isMaterial)
          CheckboxListTile.adaptive(
            title: const Text('Use classic material'),
            subtitle: const Text(
              'Do you want to use the good old material 2 theme design?',
            ),
            secondary: const Icon(Icons.android),
            value: state.themeSystem == AppThemeSystem.material2,
            onChanged: (value) {
              final settingsBloc = context.read<SettingsCubit>();
              settingsBloc.updateSettings(
                settingsBloc.state.copyWith(
                  themeSystem: (value ?? false)
                      ? AppThemeSystem.material2
                      : AppThemeSystem.material3,
                ),
              );
            },
          ),
        ListTile(
          title: const Text('Layout Mode'),
          subtitle: const Text(
              'Which layout you prefer? by default we will choose default value based on your device'),
          leading: const Icon(Icons.view_module),
          trailing: DropdownButton<AppLayoutMode>(
            value: state.layoutMode,
            items: AppLayoutMode.values
                .map(
                  (e) => DropdownMenuItem<AppLayoutMode>(
                    value: e,
                    child: Text(e.name),
                  ),
                )
                .toList(),
            onChanged: (newLayout) {
              if (newLayout == null) {
                return;
              }
              context
                  .read<SettingsCubit>()
                  .updateSettings(state.copyWith(layoutMode: newLayout));
            },
          ),
        ),
      ],
    );
  }
}

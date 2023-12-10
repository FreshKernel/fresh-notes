import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/settings/cubit/settings_data.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/extensions/build_context_ext.dart';
import '../../utils/extensions/settings_data_exts.dart';
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
                title: context.loc.notes,
                tiles: [
                  CheckboxListTile.adaptive(
                    value: state.confirmDeleteNote,
                    onChanged: (newValue) {
                      context.read<SettingsCubit>().updateSettings(
                            state.copyWith(confirmDeleteNote: newValue!),
                          );
                    },
                    title: Text(context.loc.confirmDeleteNote),
                    subtitle: Text(context.loc.confirmDeleteNoteDesc),
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
                    title: Text(context.loc.syncWithCloudByDefault),
                    subtitle: Text(
                      context.loc.syncWithCloudByDefaultDesc,
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
                child: Text(context.loc.clear),
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
      title: context.loc.general,
      tiles: [
        ListTile(
          title: Text(context.loc.appLanguage),
          subtitle: Text(context.loc.appLanguageDesc),
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
          title: Text(context.loc.themeMode),
          subtitle: Text(
            context.loc.themeModeDesc,
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
              title: Text(context.loc.darkModeDuringDay),
              subtitle: Text(
                context.loc.darkModeDuringDayDesc,
              ),
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
        ),
        if (context.isMaterial)
          CheckboxListTile.adaptive(
            title: Text(context.loc.useClassicMaterial),
            subtitle: Text(
              context.loc.useClassicMaterialDesc,
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
          title: Text(context.loc.layoutMode),
          subtitle: Text(context.loc.layoutModeDesc),
          leading: const Icon(Icons.view_module),
          trailing: DropdownButton<AppLayoutMode>(
            value: state.layoutMode,
            items: AppLayoutMode.values
                .map(
                  (e) => DropdownMenuItem<AppLayoutMode>(
                    value: e,
                    child: Text(e.getLabel(context)),
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

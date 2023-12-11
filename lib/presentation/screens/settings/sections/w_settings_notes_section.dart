import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../l10n/extensions/localizations.dart';
import '../w_settings_section.dart';

class SettingsNotesSection extends StatelessWidget {
  const SettingsNotesSection({required this.state, super.key});

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.notes,
      tiles: [
        CheckboxListTile.adaptive(
          value: state.confirmDeleteNote,
          onChanged: (newValue) {
            if (newValue == null) {
              return;
            }
            context.read<SettingsCubit>().updateSettings(
                  state.copyWith(confirmDeleteNote: newValue),
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
                  state.copyWith(syncWithCloudDefaultValue: newValue!),
                );
          },
          title: Text(context.loc.syncWithCloudByDefault),
          subtitle: Text(
            context.loc.syncWithCloudByDefaultDesc,
          ),
          secondary: const Icon(Icons.cloud),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../l10n/extensions/localizations.dart';
import 'sections/w_settings_about_section.dart';
import 'sections/w_settings_general_section.dart';
import 'sections/w_settings_notes_section.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Column(
            children: [
              SettingsGeneralSection(state: state),
              SettingsNotesSection(
                state: state,
              ),
              SettingsAboutSection(state: state),
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

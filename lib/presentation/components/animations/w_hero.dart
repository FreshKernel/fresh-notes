import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';

class MaybeHeroWidget extends StatelessWidget {
  const MaybeHeroWidget({
    required this.tag,
    required this.child,
    super.key,
  });

  final Object tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.isAnimationsEnabled != current.isAnimationsEnabled,
      builder: (context, state) {
        if (state.isAnimationsEnabled) {
          return child;
        }
        return Hero(tag: tag, child: child);
      },
    );
  }
}

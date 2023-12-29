import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'settings_data.dart';

part 'settings_cubit.freezed.dart';
part 'settings_cubit.g.dart';
part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  static const boxName = 'settings';

  void updateSettings(SettingsState newSettingsState) {
    emit(newSettingsState);
  }

  void updateAppLanguague(AppLanguague newAppLanguague) {
    updateSettings(state.copyWith(appLanguague: newAppLanguague));
  }

  void showOnBoardingScreen(bool value) {
    updateSettings(state.copyWith(openOnBoardingScreen: value));
  }

  void clearData() {
    emit(const SettingsState());
    clear();
  }

  static bool buildWhen(SettingsState previous, SettingsState current) {
    // Rebuild the whole app only if some values changes

    return previous.themeMode != current.themeMode ||
        previous.darkDuringDayInAutoMode != current.darkDuringDayInAutoMode ||
        previous.appLanguague != current.appLanguague ||
        previous.themeSystem != current.themeSystem ||
        previous.openOnBoardingScreen != current.openOnBoardingScreen;
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}

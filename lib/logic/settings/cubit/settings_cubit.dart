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

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedMixin;

part 'settings_cubit.freezed.dart';
part 'settings_cubit.g.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> with HydratedMixin {
  SettingsCubit() : super(const SettingsState());

  // TODO: Make this private and add more methods instead
  void updateSettings(SettingsState newSettingsState) {
    emit(newSettingsState);
  }

  void updateAppLanguague(AppLanguague newAppLanguague) {
    emit(state.copyWith(appLanguague: newAppLanguague));
  }

  void showOnBoardingScreen(bool value) {
    emit(state.copyWith(openOnBoardingScreen: value));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }

  static bool buildWhen(SettingsState previous, SettingsState current) {
    // Rebuild the whole app only if some values changes

    return previous.themeMode != current.themeMode ||
        previous.darkDuringDayInAutoMode != current.darkDuringDayInAutoMode ||
        previous.appLanguague != current.appLanguague ||
        previous.themeSystem != current.themeSystem ||
        previous.openOnBoardingScreen != current.openOnBoardingScreen;
  }
}

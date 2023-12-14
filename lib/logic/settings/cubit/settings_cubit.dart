import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedMixin;

import 'settings_data.dart';

part 'settings_cubit.freezed.dart';
part 'settings_cubit.g.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    Hive.openBox(boxName).then((value) {
      final json = value.get(
        'json',
      );
      if (json == null) {
        return;
      }
      emit(
        SettingsState.fromJson(
          (json as Map<dynamic, dynamic>).map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        ),
      );
    });
  }

  static const boxName = 'settings';

  void updateSettings(SettingsState newSettingsState) {
    emit(newSettingsState);
    Hive.box(boxName).put(
      'json',
      state.toJson(),
    );
  }

  void updateAppLanguague(AppLanguague newAppLanguague) {
    updateSettings(state.copyWith(appLanguague: newAppLanguague));
  }

  void showOnBoardingScreen(bool value) {
    updateSettings(state.copyWith(openOnBoardingScreen: value));
  }

  void clearData() {
    // clear();
    Hive.box(boxName).clear();
  }

  // @override
  // SettingsState? fromJson(Map<String, dynamic> json) {
  //   return SettingsState.fromJson(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(SettingsState state) {
  //   return state.toJson();
  // }

  static bool buildWhen(SettingsState previous, SettingsState current) {
    // Rebuild the whole app only if some values changes

    return previous.themeMode != current.themeMode ||
        previous.darkDuringDayInAutoMode != current.darkDuringDayInAutoMode ||
        previous.appLanguague != current.appLanguague ||
        previous.themeSystem != current.themeSystem ||
        previous.openOnBoardingScreen != current.openOnBoardingScreen;
  }
}

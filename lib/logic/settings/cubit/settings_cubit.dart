import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'settings_data.dart';

part 'settings_cubit.freezed.dart';
part 'settings_cubit.g.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    final settingsBox = Hive.box(boxName);
    final json = settingsBox.get(
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
    Hive.box(boxName).clear();
    emit(const SettingsState());
  }

  @override
  Future<void> close() async {
    await Hive.box(boxName).close();
    return super.close();
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

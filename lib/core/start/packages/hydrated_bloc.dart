import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../services/s_app.dart';

class HydratedBlocService extends AppService {
  var _isInitialized = false;

  @override
  Future<void> deInitialize() async {
    // HydratedBloc.storage = null;
    Hive.close();
    _isInitialized = false;
  }

  @override
  Future<void> initialize() async {
    final storageDirectory = kIsWeb
        ? Directory('')
        : Directory(
            join((await getApplicationDocumentsDirectory()).path, 'hydrated'));
    // HydratedBloc.storage = await HydratedStorage.build(
    //   storageDirectory: storageDirectory
    // );
    await Hive.openBox(
      SettingsCubit.boxName,
      path: storageDirectory.path,
    );
    _isInitialized = true;
  }

  @override
  bool get isInitialized => _isInitialized;
}

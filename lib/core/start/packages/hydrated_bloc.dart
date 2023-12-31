import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../service/s_app.dart';

class HydratedBlocService extends AppService {
  var _isInitialized = false;

  @override
  Future<void> deInitialize() async {
    HydratedBloc.storage = null;
    _isInitialized = false;
  }

  @override
  Future<void> initialize() async {
    final storageDirectory = kIsWeb
        ? Directory('')
        : Directory(
            join((await getApplicationDocumentsDirectory()).path, 'hydrated'));
    HydratedBloc.storage =
        await HydratedStorage.build(storageDirectory: storageDirectory);
    _isInitialized = true;
  }

  @override
  bool get isInitialized => _isInitialized;
}

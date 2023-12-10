import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/s_app.dart';

class HydratedBlocService extends AppService {
  var _isInitialized = false;

  @override
  Future<void> deInitialize() async {
    HydratedBloc.storage = null;
    _isInitialized = false;
  }

  @override
  Future<void> initialize() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'hydrated');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory:
          kIsWeb ? HydratedStorage.webStorageDirectory : Directory(path),
    );
    _isInitialized = true;
  }

  @override
  bool get isInitialized => _isInitialized;
}

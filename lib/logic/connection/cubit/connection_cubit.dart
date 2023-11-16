import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/app_module.dart';
import '../../native/connection/connection_type.dart';
import '../../utils/platform_checker.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnState> {
  ConnectionCubit() : super(ConnState.initial()) {
    _connectionSubscription = _connectionCheckerService
        .monitorInternetConnectionStatus()
        .listen((connectionType) {
      if (!connectionType.hasInternetConnection) {
        emit(ConnStateInternetDisconnected(connectionType));
        return;
      }
      emit(ConnStateInternetConnected(connectionType));
    });
  }

  final _connectionCheckerService = AppModule.connectionCheckerService;
  late final StreamSubscription<ConnectionType> _connectionSubscription;

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}

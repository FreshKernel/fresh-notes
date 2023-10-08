import 'package:connectivity_plus/connectivity_plus.dart';

import '../connection_checker.dart';
import '../connection_type.dart';

class ConnectionCheckerConnectivityPlusImpl extends ConnectionChecker {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<ConnectionType> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _fromConnectivityResult(result);
  }

  ConnectionType _fromConnectivityResult(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      return const NoConnectionType();
    }
    if (result == ConnectivityResult.wifi) {
      return const WifiConnectionType(true);
    }
    if (result == ConnectivityResult.mobile) {
      return const MobileConnectionType(true);
    }
    return const UnknownConnectionType(true);
  }

  @override
  Stream<ConnectionType> monitorInternetConnectionStatus() async* {
    await for (final result in _connectivity.onConnectivityChanged) {
      yield _fromConnectivityResult(result);
    }
  }
}

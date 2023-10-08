import 'connection_type.dart';

abstract class ConnectionChecker {
  const ConnectionChecker();
  Future<ConnectionType> hasInternetConnection();
  Stream<ConnectionType> monitorInternetConnectionStatus();
}

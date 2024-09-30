import '../../../core/app_module.dart';
import 'connection_checker.dart';
import 'connection_type.dart';
import 'fake_connection_checker.dart';

class ConnectionCheckerService extends ConnectionChecker {
  const ConnectionCheckerService(this._connectionChecker);

  factory ConnectionCheckerService.connectivityPlus() =>
      ConnectionCheckerService(
        FakeConnectionChecker(),
      );

  factory ConnectionCheckerService.getInstance() =>
      AppModule.connectionCheckerService;

  final ConnectionChecker _connectionChecker;

  @override
  Future<ConnectionType> hasInternetConnection() =>
      _connectionChecker.hasInternetConnection();

  @override
  Stream<ConnectionType> monitorInternetConnectionStatus() =>
      _connectionChecker.monitorInternetConnectionStatus();
}

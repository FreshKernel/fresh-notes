import 'connection_checker.dart';
import 'connection_type.dart';

class FakeConnectionChecker extends ConnectionChecker {
  @override
  Future<ConnectionType> hasInternetConnection() async {
    // TODO: connectivity_plus was removed due to build failure and some other issues
    // such as always requiring the latest Kotlin version as the minimum which
    // causing issues in production mode
    return const WifiConnectionType(true);
  }

  @override
  Stream<ConnectionType> monitorInternetConnectionStatus() async* {}
}

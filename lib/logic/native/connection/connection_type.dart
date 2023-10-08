sealed class ConnectionType {
  const ConnectionType(this.hasInternetConnection);

  final bool hasInternetConnection;
}

final class WifiConnectionType extends ConnectionType {
  const WifiConnectionType(super.hasInternetConnection);
}

final class MobileConnectionType extends ConnectionType {
  const MobileConnectionType(super.hasInternetConnection);
}

final class NoConnectionType extends ConnectionType {
  const NoConnectionType() : super(false);
}

final class UnknownConnectionType extends ConnectionType {
  const UnknownConnectionType(super.hasInternetConnection);
}

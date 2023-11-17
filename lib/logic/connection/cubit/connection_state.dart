part of 'connection_cubit.dart';

@immutable
sealed class ConnState extends Equatable {
  const ConnState(this.connectionType);
  factory ConnState.initial() => !PlatformChecker.defaultLogic().isWeb()
      ? const ConnStateInternetDisconnected(UnknownConnectionType(false))
      : const ConnStateInternetConnected(UnknownConnectionType(true));
  final ConnectionType connectionType;

  @override
  List<Object?> get props => [connectionType];
}

final class ConnStateInternetConnected extends ConnState {
  const ConnStateInternetConnected(super.connectionType);
}

final class ConnStateInternetDisconnected extends ConnState {
  const ConnStateInternetDisconnected(super.connectionType);
}

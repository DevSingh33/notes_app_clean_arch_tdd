part of 'connection_checker_cubit.dart';

abstract class ConnectionCheckerState extends Equatable {
  const ConnectionCheckerState();

  @override
  List<Object> get props => [];
}

class ConnectionCheckerInitial extends ConnectionCheckerState {}
class ConnectionCheckerLoading extends ConnectionCheckerState {}
class InternetConnected extends ConnectionCheckerState {}
class InternetDisconnected extends ConnectionCheckerState {}

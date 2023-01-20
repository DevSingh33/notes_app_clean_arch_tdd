import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'connection_checker_state.dart';

class ConnectionCheckerCubit extends Cubit<ConnectionCheckerState> {
  final InternetConnectionChecker internetConnectionChecker;
  ConnectionCheckerCubit(this.internetConnectionChecker) : super(ConnectionCheckerInitial());
  StreamSubscription<InternetConnectionStatus>? _listener;
  // actively listen for status updates

  bool isConnected = false;
  Future<void> checkInternet() async {
    emit(ConnectionCheckerLoading());
    _listener = internetConnectionChecker.onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        isConnected = true;
        emit(InternetConnected());
      } else {
        isConnected = false;
        emit(InternetDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _listener!.cancel();
    return super.close();
  }
}

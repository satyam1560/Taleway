import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import '/models/failure.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityBloc({required Connectivity connectivity})
      : _connectivity = connectivity,
        super(ConnectivityState.initial()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        //emit(state.copyWith(status: ConnectivityStatus.error));
      }
    });
    on<ConnectivityEvent>((event, emit) {
      if (event is ConnectivityChanged) {
        _connectivitySubscription =
            _connectivity.onConnectivityChanged.listen((result) {
          if (result == ConnectivityResult.none) {
            emit(state.copyWith(status: ConnectivityStatus.error));
          }
        });
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}

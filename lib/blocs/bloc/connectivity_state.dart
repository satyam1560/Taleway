part of 'connectivity_bloc.dart';

enum ConnectivityStatus { initial, error }

class ConnectivityState extends Equatable {
  final ConnectivityStatus status;
  final Failure failure;

  const ConnectivityState({required this.status, required this.failure});

  @override
  List<Object> get props => [status, failure];

  factory ConnectivityState.initial() {
    return const ConnectivityState(
        status: ConnectivityStatus.initial, failure: Failure());
  }

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    Failure? failure,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

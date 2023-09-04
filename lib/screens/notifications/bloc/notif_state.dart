part of 'notif_bloc.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotifState extends Equatable {
  final List<Notif?>? notifications;
  final NotificationsStatus status;
  final Failure failure;

  const NotifState({
    required this.notifications,
    required this.status,
    required this.failure,
  });

  @override
  factory NotifState.initial() {
    return const NotifState(
      notifications: [],
      status: NotificationsStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [notifications, status, failure];

  NotifState copyWith({
    List<Notif?>? notifications,
    NotificationsStatus? status,
    Failure? failure,
  }) {
    return NotifState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

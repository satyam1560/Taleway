part of 'notif_bloc.dart';

abstract class NotifEvent extends Equatable {
  const NotifEvent();

  @override
  List<Object> get props => [];
}

class NotificationsUpdateNotifications extends NotifEvent {
  final List<Notif?> notifications;

  const NotificationsUpdateNotifications({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/failure.dart';
import '/models/notif.dart';
import '/repositories/notif/notif_repository.dart';

part 'notif_event.dart';
part 'notif_state.dart';

class NotifBloc extends Bloc<NotifEvent, NotifState> {
  final NotificationRepository _notifRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Notif?>>>? _notificationsSubscription;

  NotifBloc({
    required NotificationRepository notificationRepository,
    required AuthBloc authBloc,
  })  : _notifRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotifState.initial()) {
    // emit(state.copyWith(status: NotificationsStatus.loading));
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _notifRepository
        .getUserNotifications(userId: _authBloc.state.user?.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      print('All notifications -- $allNotifications');
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });

    on<NotifEvent>((event, emit) {
      if (event is NotificationsUpdateNotifications) {
        emit(state.copyWith(
          notifications: event.notifications,
          status: NotificationsStatus.loaded,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}

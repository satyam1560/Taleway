import '/models/notif.dart';

abstract class BaseNotifRepo {
  Stream<List<Future<Notif?>>> getUserNotifications({required String? userId});
}

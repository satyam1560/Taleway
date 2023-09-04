import 'package:cloud_firestore/cloud_firestore.dart';
import '/config/paths.dart';
import '/models/notif.dart';

import 'base_notif_repo.dart';

class NotificationRepository extends BaseNotifRepo {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notif?>>> getUserNotifications({required String? userId}) {
    print('notification user id -- $userId');
    return _firestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList());
  }
}

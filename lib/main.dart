import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/services/local_notification_service.dart';
import '/screens/feed/bloc/feed_bloc.dart';
import '/repositories/notif/notif_repository.dart';
import '/repositories/feed/feed_repository.dart';
import '/repositories/comment/comment_repository.dart';
import '/repositories/story/story_repository.dart';
import '/repositories/user/user_repository.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/auth/auth_repo.dart';
import 'config/auth_wrapper.dart';
import 'config/custom_router.dart';
import 'config/shared_prefs.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  // await FirebaseMessaging.instance.requestPermission();
  print(message.data.toString());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
// /// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String?> selectNotificationSubject =
//     BehaviorSubject<String?>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAog5tvJGNb63Hjbe6TpPVPW_Qp_D9iKRs',
        appId: '1:526121573343:web:b0caef970924f065c6c26a',
        messagingSenderId: '526121573343',
        projectId: 'viewyourstories-4bf4d',
        storageBucket: 'viewyourstories-4bf4d.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

//  await _configureLocalTimeZone();

  EquatableConfig.stringify = kDebugMode;

  //Bloc.observer = SimpleBlocObserver();
  EquatableConfig.stringify = kDebugMode;
  await SharedPrefs().init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

// Future<void> _configureLocalTimeZone() async {
//   if (kIsWeb || Platform.isLinux) {
//     return;
//   }
//   tz.initializeTimeZones();
//   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName!));
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<StoryRepository>(
          create: (_) => StoryRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<CommentsRepository>(
          create: (_) => CommentsRepository(),
        ),
        RepositoryProvider<FeedRepository>(
          create: (_) => FeedRepository(),
        ),
        RepositoryProvider(
          create: (_) => NotificationRepository(),
        ),
        RepositoryProvider<NotificationService>(
          create: (_) => NotificationService(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => FeedBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
            )..add(RefreshFeed()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Helvetica'),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: AuthWrapper.routeName,
        ),
      ),
    );
  }
}

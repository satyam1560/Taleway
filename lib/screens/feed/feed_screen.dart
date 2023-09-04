import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'package:universal_platform/universal_platform.dart';
import 'package:viewstories/screens/comments/comments_screen.dart';
import 'package:viewstories/screens/others-profile/others_profile_screen.dart';
import '/config/paths.dart';
import '/config/shared_prefs.dart';
import '/services/local_notification_service.dart';
import '/utils/constants.dart';
import '/screens/feed-collection/feed_collection.dart';
import '/screens/profile/profile_screen.dart';
import '/widgets/show_snackbar.dart';
import '/screens/notifications/notifications_screen.dart';
import '/repositories/user/user_repository.dart';
import '/repositories/story/story_repository.dart';
import '/screens/feed/widgets/cubit/feed_story_cubit.dart';
import '/widgets/custom_gradient_btn.dart';
import '/widgets/gradient_circle_button.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/feed/feed_repository.dart';
import '/widgets/loading_indicator.dart';
import '/screens/search/search_screen.dart';
import '/screens/create-post/create_post_screen.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/custom_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/feed_bloc.dart';
import 'widgets/feed_story_section.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => FeedBloc(
          feedRepository: context.read<FeedRepository>(),
          authBloc: context.read<AuthBloc>(),
          userRepository: context.read<UserRepository>(),
        )..add(RefreshFeed()),
        child: const FeedScreen(),
      ),
    );
  }

  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> _onRefresh(BuildContext context) async {
    print('refresh runs ');
    context.read<FeedBloc>().add(RefreshFeed());
  }

  void closeApp() {
    if (UniversalPlatform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (UniversalPlatform.isIOS) {
      // MinimizeApp.minimizeApp();
    }
  }

  void _addNewFeedCollection(BuildContext context) async {
    print('This tuns');
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => context.read<FeedBloc>().add(
                    NewCollectionNameChanged(collName: value),
                  ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Add new collection',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            CustomGradientBtn(
              label: 'Submit',
              onTap: () {
                context.read<FeedBloc>().add(AddNewFeedCollection());
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 12.0),
          ],
        );
      },
    );
  }

  Future<void> _shareApp() async {
    try {
      await Share.share(
          'check out this app https://play.google.com/store/apps/details?id=com.sixteenbrains.oriental_management');
    } catch (error) {
      print('Error sharing story');
    }
  }

  // notifications
  @override
  void initState() {
    super.initState();

    _notificationSetup();

    if (!UniversalPlatform.isWeb) {
      print('this init runs');
      tz.initializeTimeZones();
      RepositoryProvider.of<NotificationService>(context)
          .initialiseSettings(onSelectNotification);
    }
  }

  bool _isLoading = false;

  Future<void> _notificationSetup() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // asking for permissions
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      String? token = await messaging.getToken();
      //await messaging.deleteToken();
      print('FCM Token $token');

      print('Device token $token');
      print(
          'First time status ${SharedPrefs().isFirstTime}'); // if (token != null && !SharedPrefs().isFirstTime) {
      if (token != null) {
        print('server notification runs');

        // Save the initial token to the database
        await saveTokenToDatabase(token);

        // Any time the token refreshes, store this in the database too.
        FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

        //  await _serverNotification(token);
        SharedPrefs().setFirstTime();
        SharedPrefs().setNotificationStatus(true);
      }

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('Notification Settings $settings');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        //gives you the message on which user taps and it opened the app from terminated state

        //    await messaging.getAPNSToken();
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            // context
            //     .read<NavBloc>()
            //     .add(const UpdateNavItem(item: NavItem.store));
            print('Message1 $message');

            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     AuthWrapper.routeName, (route) => false);

            // if (message.data['route'] == 'public') {
            //   // BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.public));
            // }
          }
        });

        ///Forground ( When the app is running in the forground )
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Message 2 ${message.notification?.body}');
          // print('Message 2 ${message.notification.android.imageUrl}');
          print('Message 2 ${message.notification}');
          print('Mesage 3 ${message.data.runtimeType}');
          //print('Mesage 3 ${message.data['icons']}');
          print('Mesage 3 ${message.data}');

          if (message.notification != null) {
            final notification = context.read<NotificationService>();

            final String? storyId = message.data['storyId'];
            final String? storyAuthorId = message.data['storyAuthorId'];
            final String? icon = message.data['icon'];
            final String? followerId = message.data['followerId'];

            if (storyId != null && storyAuthorId != null) {
              // this is comment notificaiton from server
              notification.showNotificationMediaStyle(
                title: message.notification?.title ?? '',
                body: message.notification?.body ?? '',
                payload: jsonEncode({
                  'storyId': storyId,
                  'storyAuthorId': storyAuthorId,
                }),
                mediaUrl: icon ?? profilePlaceholderImg,
              );
            }
            // follower notification from server
            if (followerId != null) {
              notification.showNotificationMediaStyle(
                title: message.notification?.title ?? '',
                body: message.notification?.body ?? '',
                payload: jsonEncode({
                  'type': 'followerNotif',
                  'followerId': followerId,
                }),
                mediaUrl: icon ?? profilePlaceholderImg,
              );
            }

            // else {
            //   notification.showNotification(
            //     title: message.notification?.title ?? '',
            //     body: message.notification?.body ?? '',
            //     payload: 'no-action',
            //   );
            // }
          }
          // else {
          //   // TODO: work on this follower notifications
          //   if (message.data.isNotEmpty) {
          //     final followerData =
          //         jsonDecode(message.data['follower']) as Map<String, dynamic>?;

          //     final followerUserName =
          //         followerData?['_fieldsProto']['username']['stringValue'];
          //     print('this notif is not null');
          //     final notification = context.read<NotificationService>();
          //     notification.showNotification(
          //       title: 'New Follower',
          //       body: '${followerUserName ?? 'N/A'} followed you',
          //       payload: 'no-action',
          //     );
          //   }
          // }
        });

        ///When the app is in background but opened and user taps
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          print('Message2 ${message.data}');
          // context.read<NavBloc>().add(const UpdateNavItem(item: NavItem.store));
          // if (message.data['route'] == 'public') {
          //   // BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.public));
          // }
        });
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error in Firebase message ${error.toString()}');
      setState(() {
        _isLoading = false;
      });
      print(error.toString());
    }
  }

  Future<void> onSelectNotification(String? payload) async {
    print('Nofication Clicked');
    print('Payload $payload');

    if (payload != null) {
      final notifData = jsonDecode(payload) as Map?;
      print('Comments data $notifData');

      if (notifData != null) {
        final String? storyId = notifData['storyId'];
        final String? storyAuthorId = notifData['storyAuthorId'];
        final notifType = notifData['type'];
        final followerId = notifData['followerId'];

        if (notifType == 'followerNotif' && followerId != null) {
          Navigator.of(context).pushNamed(OthersProfileScreen.routeName,
              arguments: OthersProfileScreenArgs(othersProfileId: followerId));
        } else if (storyAuthorId != null && storyId != null) {
          Navigator.of(context).pushNamed(
            CommentsScreen.routeName,
            arguments: CommentsScreenArgs(
              storyId: storyId,
              storyAuthorId: storyAuthorId,
            ),
          );
        }
      }
    }

//     final Map? payload = jsonDecode(payload);

    /// context.read<NavBloc>().add(const UpdateNavItem(item: NavItem.store));

    if (payload == 'public') {
      //  BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.public));
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    try {
      // Assume user is logged in for this example
      print('server notification runs');

      final _authBloc = context.read<AuthBloc>();

      await FirebaseFirestore.instance
          .collection(Paths.users)
          .doc(_authBloc.state.user?.uid)
          .update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    } catch (error) {
      print('Error adding token to the server ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        closeApp();
        return true;
      },
      child: Container(
        decoration: gradientBackground,
        height: double.infinity,
        width: double.infinity,
        child: _isLoading
            ? const LoadingIndicator()
            : BlocConsumer<FeedBloc, FeedState>(
                listener: (context, state) {
                  print('State of feed bloc ----${state.status}');
                  print('App user ------- ${state.appUser}');
                },
                builder: (context, state) {
                  if (state.status == FeedStatus.succuss) {
                    final storiesLabel = state.collectionNames;

                    final name = state.appUser?.name?.split(' ')[0] ?? '';
                    print('Spiltted name  $name');

                    return SafeArea(
                      child: Scaffold(
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        floatingActionButton: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                print('This tnssss');
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GradientCircleButton(
                                  onTap: () {
                                    _addNewFeedCollection(context);

                                    // final notification =
                                    //     context.read<NotificationService>();
                                    // notification.showNotification(
                                    //   title: 'Notification Title',
                                    //   body: 'Notification Body',
                                    //   payload: 'Notification Payload',
                                    // );
                                  },
                                  icon: Icons.add,
                                ),
                              ),
                            ),
                            const Text(
                              'Create New Collection',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                        backgroundColor: Colors.transparent,
                        body: RefreshIndicator(
                          onRefresh: () => _onRefresh(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 2.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: _canvas.width * 0.4,
                                      height: 30,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Hey ',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.1,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: _shareApp,
                                      icon: const Icon(
                                        Icons.share,
                                        size: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(
                                              NotificationScreen.routeName),
                                      icon: const Icon(
                                        Icons.notifications,
                                        size: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed(SearchScreen.routeName),
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(ProfileScreen.routeName),
                                      child: AvatarWidget(
                                        imageUrl: state.appUser?.profilePic,
                                        size: 70.0,
                                      ),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Create a post',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // const SizedBox(width: 20.0),

                                            //const SizedBox(width: 10.0),
                                            CustomIcons(
                                              icon: Icons.image,
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(CreatePostScreen
                                                      .routeName),
                                            ),
                                            const SizedBox(width: 12.0),
                                            CustomIcons(
                                              icon: Icons.camera_alt,
                                              onTap: () {
                                                ShowSnackBar.showSnackBar(
                                                  context,
                                                  title:
                                                      'This feature is not available now',
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 12.0),
                                            CustomIcons(
                                              icon: Icons.video_call,
                                              onTap: () {
                                                ShowSnackBar.showSnackBar(
                                                    context,
                                                    title:
                                                        'This feature is not available now');
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                      ],
                                    )
                                  ],
                                ),
                                // const SizedBox(height: 12.0),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: storiesLabel.length,
                                      itemBuilder: (context, index) {
                                        final label = storiesLabel[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final result = await Navigator
                                                          .of(context)
                                                      .pushNamed(
                                                          FeedCollection
                                                              .routeName,
                                                          arguments:
                                                              FeedCollectionArgs(
                                                                  collectionName:
                                                                      label));

                                                  if (result != null) {
                                                    context
                                                        .read<FeedBloc>()
                                                        .add(RefreshFeed());
                                                  }
                                                },
                                                child: Text(
                                                  label ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.9,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              BlocProvider<FeedStoryCubit>(
                                                create: (context) =>
                                                    FeedStoryCubit(
                                                  storyRepository: context
                                                      .read<StoryRepository>(),
                                                  feedRepository: context
                                                      .read<FeedRepository>(),
                                                  authBloc:
                                                      context.read<AuthBloc>(),
                                                  collectionName: label,
                                                )..loadFeedStories(),
                                                child: FeedStorySection(
                                                    collectionName: label),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return const LoadingIndicator();
                },
              ),
      ),
    );
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;

  @override
  _ShimmerLoadingState createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return shimmerGradient.createShader(bounds);
      },
      child: widget.child,
    );
  }
}

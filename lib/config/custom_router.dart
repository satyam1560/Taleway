import 'package:flutter/material.dart';
import 'package:viewstories/screens/profile-collection/profile_collection.dart';
import 'package:viewstories/screens/user-stories/user_stories_screen.dart';
import '../screens/feed-collection/feed_collection.dart';
import '/screens/connectivity/connectivity_screen.dart';
import '/screens/followings/followings_screen.dart';
import '/screens/notifications/notifications_screen.dart';
import '/screens/view-story/story_screen.dart';
import '/screens/feed/feed_screen.dart';
import '/screens/comments/comments_screen.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/screens/view-story/view_story_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/search/search_screen.dart';
import '/screens/edit-profile/edit_profile_screen.dart';
import '/screens/create-post/create_post_screen.dart';
import '/screens/forget-password/forget_password_screen.dart';
import '/screens/signup/signup_screen.dart';
import '/screens/login/login_screen.dart';
import 'auth_wrapper.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => const Scaffold());

      case AuthWrapper.routeName:
        return AuthWrapper.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignupScreen.routeName:
        return SignupScreen.route();

      case FeedScreen.routeName:
        return FeedScreen.route();

      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();

      case CreatePostScreen.routeName:
        return CreatePostScreen.route();

      // case ViewStoryScreen.routeName:
      //   return ViewStoryScreen.route();

      case EditProfleScreen.routeName:
        return EditProfleScreen.route();

      case ProfileScreen.routeName:
        return ProfileScreen.route();

      case SearchScreen.routeName:
        return SearchScreen.route();

      case CommentsScreen.routeName:
        return CommentsScreen.route(
            args: settings.arguments as CommentsScreenArgs);

      case ViewStoryScreen.routeName:
        return ViewStoryScreen.route(
            args: settings.arguments as ViewStoryScreenArgs);

      case OthersProfileScreen.routeName:
        return OthersProfileScreen.route(
            args: settings.arguments as OthersProfileScreenArgs);

      case StoryScreen.routeName:
        return StoryScreen.route(args: settings.arguments as StoryScreenArgs);

      case NotificationScreen.routeName:
        return NotificationScreen.route();

      case FollowingScreen.routeName:
        return FollowingScreen.route();

      case ConnectivityScreen.routeName:
        return ConnectivityScreen.route();

      case FeedCollection.routeName:
        return FeedCollection.route(
            args: settings.arguments as FeedCollectionArgs);

      case ProfileCollection.routeName:
        return ProfileCollection.route(
            args: settings.arguments as ProfileCollectionArgs);

      case UserStoriesScreen.routeName:
        return UserStoriesScreen.route(
            args: settings.arguments as UserStoriesArgs);

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRouter(RouteSettings settings) {
    print('NestedRoute: ${settings.name}');
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Error',
          ),
        ),
        body: const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

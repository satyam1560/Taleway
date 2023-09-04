import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/view-story/view_story_screen.dart';
import '/utils/constants.dart';
import '/widgets/gradient_circle_button.dart';
import '/repositories/story/story_repository.dart';
import '/screens/user-stories/bloc/user_stories_bloc.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/loading_indicator.dart';

class UserStoriesArgs {
  final String? userId;
  final String? username;

  UserStoriesArgs({
    required this.userId,
    required this.username,
  });
}

class UserStoriesScreen extends StatelessWidget {
  static const String routeName = '/user-stories';

  const UserStoriesScreen({
    Key? key,
    required this.userId,
    required this.username,
  }) : super(key: key);

  final String? userId;
  final String? username;

  static Route route({
    required UserStoriesArgs args,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => UserStoriesBloc(
            storyRepository: context.read<StoryRepository>(),
            userId: args.userId)
          ..add(LoadUserStories()),
        child: UserStoriesScreen(
          userId: args.userId,
          username: args.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<UserStoriesBloc, UserStoriesState>(
          listener: (context, snapshot) {},
          builder: (context, snapshot) {
            if (snapshot.status == UserStoriesStatus.succuss) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        GradientCircleButton(
                          onTap: () => Navigator.of(context).pop(),
                          icon: Icons.arrow_back,
                        ),
                        const SizedBox(width: 14.0),
                        Text(
                          username ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.stories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 130.0,
                          mainAxisSpacing: 5.0,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          final story = snapshot.stories[index];

                          return Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ViewStoryScreen.routeName,
                                      arguments:
                                          ViewStoryScreenArgs(story: story),
                                    );
                                    // if (_authBloc.state.user?.uid == user?.uid) {
                                    //   Navigator.of(context)
                                    //       .pushNamed(ProfileScreen.routeName);
                                    // } else {
                                    //   Navigator.of(context).pushNamed(
                                    //     OthersProfileScreen.routeName,
                                    //     arguments: OthersProfileScreenArgs(
                                    //         othersProfileId: user?.uid),
                                    //   );
                                    // }
                                  },
                                  child:
                                      AvatarWidget(imageUrl: story?.storyUrl)),
                              // Text(
                              //   user?.name ?? 'N/A',
                              //   style: const TextStyle(color: Colors.white),
                              //   overflow: TextOverflow.ellipsis,
                              // )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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

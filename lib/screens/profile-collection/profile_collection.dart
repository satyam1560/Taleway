import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/constants.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/user/user_repository.dart';
import '/screens/view-story/view_story_screen.dart';
import '/blocs/profile-story/profile_story_cubit.dart';
import '/repositories/story/story_repository.dart';

import '/widgets/gradient_circle_button.dart';

import '/widgets/avatar_widget.dart';
import '/widgets/loading_indicator.dart';

class ProfileCollectionArgs {
  final String? collectionName;
  final String? userId;

  const ProfileCollectionArgs({
    required this.collectionName,
    required this.userId,
  });
}

class ProfileCollection extends StatelessWidget {
  static const String routeName = '/profile-collection';

  final String? collectionName;
  final String? userId;

  const ProfileCollection({
    Key? key,
    required this.collectionName,
    required this.userId,
  }) : super(key: key);

  static Route route({required ProfileCollectionArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => ProfileStoryCubit(
          collectionName: args.collectionName,
          storyRepository: context.read<StoryRepository>(),
          userId: args.userId,
        ),
        child: ProfileCollection(
          collectionName: args.collectionName,
          userId: args.userId,
        ),
      ),
    );
  }

  Future<void> _deleteCollection(BuildContext context) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            title: const Text(
              'Delete Collection',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Do you want to delete $collectionName ?',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          );
        },
      );

      final bool delete = await result ?? false;
      if (delete) {
        await context.read<UserRepository>().delelteProfileStoryCollection(
            userId: userId, collectionName: collectionName);

        Navigator.of(context).pop(true);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    final _authBloc = context.read<AuthBloc>();
    return Container(
      decoration: gradientBackground,
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<ProfileStoryCubit, ProfileStoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == ProfileStoryStatus.succuss) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        GradientCircleButton(
                          onTap: () => Navigator.of(context).pop(),
                          icon: Icons.arrow_back,
                        ),
                        const SizedBox(width: 14.0),
                        SizedBox(
                          width: _canvas.width * 0.64,
                          child: Text(
                            collectionName ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.9,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        if (_authBloc.state.user?.uid == userId)
                          IconButton(
                            onPressed: () => _deleteCollection(context),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: state.stories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 0.0,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          final story = state.stories[index];
                          return Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        ViewStoryScreen.routeName,
                                        arguments:
                                            ViewStoryScreenArgs(story: story));

                                    // if (_authBloc.state.user?.uid ==
                                    //     user?.uid) {
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

// 4844410116001150

// 01/27

//585
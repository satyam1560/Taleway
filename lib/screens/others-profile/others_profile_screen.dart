import 'package:flutter/material.dart';
import '/screens/others-profile/widgets/block_user.dart';
import '/utils/constants.dart';
import '/screens/profile-collection/profile_collection.dart';
import '/widgets/add_to_feed_btn.dart';
import '/blocs/add-to-lib/add_to_collection_cubit.dart';
import '/blocs/profile-story/profile_story_cubit.dart';
import '/repositories/story/story_repository.dart';
import '/blocs/auth/auth_bloc.dart';
import '/screens/others-profile/widgets/action_buttons.dart';
import '/screens/others-profile/bloc/others_profile_bloc.dart';
import '/screens/profile/widgets/profile_stories_section.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/loading_indicator.dart';
import '/repositories/user/user_repository.dart';

import '/widgets/gradient_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OthersProfileScreenArgs {
  final String? othersProfileId;

  const OthersProfileScreenArgs({required this.othersProfileId});
}

class OthersProfileScreen extends StatelessWidget {
  static const String routeName = '/others-profile';
  const OthersProfileScreen({Key? key}) : super(key: key);

  static Route route({required OthersProfileScreenArgs? args}) {
    print('Others users id ${args?.othersProfileId}');
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OthersProfileBloc(
              otherProfileId: args?.othersProfileId,
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
            )..add(LoadOthersProfile()),
          ),
          BlocProvider(
            create: (context) => AddToCollectionCubit(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
            )..loadCollectionNames(),
          ),
        ],
        child: const OthersProfileScreen(),
      ),
    );
  }

  void _followUser(BuildContext context) async {
    context.read<OthersProfileBloc>().add(FollowUser());
    //  context.read<FeedBloc>().add(LoadUserFeed());
  }

  void _unFollowUser(BuildContext context) async {
    context.read<OthersProfileBloc>().add(UnFollowUser());

    // context.read<FeedBloc>().add(LoadUserFeed());
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<OthersProfileBloc, OthersProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            print('Profile state -- ${state.status}');
            if (state.status == OthersProfileStatus.succuss) {
              print('Check already exist -------- ${state.alreadyFollowed}');
              final user = state.user;
              final storiesLabel = state.collectionName;
              print('Stories ------ ${state.collectionName}');
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: RefreshIndicator(
                  onRefresh: () async {},
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          GradientCircleButton(
                            onTap: () => Navigator.of(context).pop(),
                            icon: Icons.arrow_back,
                          ),
                          const SizedBox(width: 14.0),
                          Text(
                            '@${user?.username ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          AvatarWidget(
                            imageUrl: user?.profilePic,
                            size: 100.0,
                            borderRadius: 100.0,
                            contentPadding: 6.0,
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: _canvas.width * 0.5,
                                child: Text(
                                  user?.name ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.group,
                                    color: Colors.white70,
                                    size: 26.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    '${state.user?.followers}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // const Spacer(),
                                  SizedBox(width: _canvas.width * 0.3),
                                  BlockUserButton(isBlocked: state.isBlocked),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        user?.bio ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      if (!state.isBlocked)
                        Row(
                          mainAxisAlignment: state.alreadyFollowed
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                          children: [
                            state.alreadyFollowed
                                ? ActionButtons(
                                    onTap: () => _unFollowUser(context),
                                    icon: Icons.person_remove,
                                    label: 'Unfollow',
                                  )
                                : ActionButtons(
                                    onTap: () => _followUser(context),
                                    icon: Icons.person_add,
                                    label: 'Follow',
                                  ),
                            state.alreadyFollowed
                                ? AddToFeedCollectionBtn(
                                    otherUserId: state.user?.uid)
                                : const SizedBox.shrink(),
                          ],
                        ),
                      const SizedBox(height: 40.0),
                      if (!state.isBlocked)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: storiesLabel
                              .map(
                                (collectionLabel) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(
                                                ProfileCollection.routeName,
                                                arguments:
                                                    ProfileCollectionArgs(
                                                        collectionName:
                                                            collectionLabel,
                                                        userId: user?.uid)),
                                        child: Text(
                                          collectionLabel ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.9,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      BlocProvider(
                                        create: (context) => ProfileStoryCubit(
                                          userId: state.user?.uid,
                                          // authBloc: context.read<AuthBloc>(),
                                          storyRepository:
                                              context.read<StoryRepository>(),
                                          collectionName: collectionLabel,
                                        ),
                                        child: ProfileStorySection(
                                            collectionName: collectionLabel),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              );
            } else {
              //return Container();
              return const LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}

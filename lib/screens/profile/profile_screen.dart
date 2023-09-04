import 'package:flutter/material.dart';
import '/utils/constants.dart';
import '/screens/user-stories/user_stories_screen.dart';
import '/screens/profile-collection/profile_collection.dart';
import '/screens/view-story/story_screen.dart';
import '/screens/followings/followings_screen.dart';
import '/widgets/custom_gradient_btn.dart';
import '/blocs/profile-story/profile_story_cubit.dart';
import '/repositories/story/story_repository.dart';
import '/widgets/loading_indicator.dart';
import '/repositories/user/user_repository.dart';
import '/screens/profile/bloc/profile_bloc.dart';
import '/blocs/auth/auth_bloc.dart';
import '/screens/edit-profile/edit_profile_screen.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/gradient_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/logout.dart';
import 'widgets/profile_stories_section.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
            storyRepository: context.read<StoryRepository>())
          ..add(LoadUserProfile()),
        child: const ProfileScreen(),
      ),
    );
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
              onChanged: (value) => context.read<ProfileBloc>().add(
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
                context.read<ProfileBloc>().add(AddNewProfileCollection());
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 12.0),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    print('refresh runs ');
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  },
                  icon: Icons.add,
                ),
              ),
            ),
            const Text(
              'Create New Library',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == ProfileStatus.succuss) {
              final user = state.appUser;
              final storiesLabel = state.collectionName;
              print('Stories ------ ${state.collectionName}');
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          const Logout(),
                          const SizedBox(width: 15.0),
                          GradientCircleButton(
                            size: 35.0,
                            onTap: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed(EditProfleScreen.routeName);
                              print('Result ------- $result');

                              if (result != null) {
                                context
                                    .read<ProfileBloc>()
                                    .add(LoadUserProfile());
                              }
                            },
                            icon: Icons.edit,
                            iconSize: 20.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (state.todaysStories.isNotEmpty) {
                                Navigator.of(context).pushNamed(
                                    StoryScreen.routeName,
                                    arguments: StoryScreenArgs(
                                        authorId: _authBloc.state.user?.uid));
                              }
                            },
                            child: AvatarWidget(
                              imageUrl: user?.profilePic,
                              size: 100.0,
                              borderRadius: 100.0,
                              contentPadding: 6.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 19.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
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
                                        '${user?.followers ?? ''}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 10.0),
                                  IconButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(FollowingScreen.routeName),
                                    icon: const Icon(
                                      Icons.groups,
                                      color: Colors.white,
                                      size: 28.0,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  IconButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(UserStoriesScreen.routeName,
                                            arguments: UserStoriesArgs(
                                                userId: user?.uid,
                                                username: user?.username)),
                                    icon: const Icon(
                                      Icons.collections,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                  )
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
                      const SizedBox(height: 40.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: storiesLabel
                            .map(
                              (label) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final result =
                                            await Navigator.of(context)
                                                .pushNamed(
                                          ProfileCollection.routeName,
                                          arguments: ProfileCollectionArgs(
                                              collectionName: label,
                                              userId: user?.uid),
                                        );

                                        if (result != null) {
                                          _onRefresh(context);
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
                                    BlocProvider(
                                      create: (_) => ProfileStoryCubit(
                                        userId: context
                                            .read<AuthBloc>()
                                            .state
                                            .user
                                            ?.uid,
                                        storyRepository:
                                            context.read<StoryRepository>(),
                                        collectionName: label,
                                      ),
                                      child: ProfileStorySection(
                                        collectionName: label,
                                      ),
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
              return const LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}

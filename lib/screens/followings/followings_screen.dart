import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/constants.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/blocs/add-to-lib/add_to_collection_cubit.dart';
import '/widgets/add_to_feed_btn.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/user/user_repository.dart';
import '/screens/followings/bloc/followings_bloc.dart';
import '/widgets/gradient_circle_button.dart';

class FollowingScreen extends StatelessWidget {
  static const routeName = '/followings';
  const FollowingScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MultiBlocProvider(providers: [
        BlocProvider<FollowingsBloc>(
          create: (context) => FollowingsBloc(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
              LoadFollowingsUsers(),
            ),
        ),
        BlocProvider(
          create: (context) => AddToCollectionCubit(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..loadCollectionNames(),
        )
      ], child: const FollowingScreen()),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  children: [
                    GradientCircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icons.arrow_back,
                    ),
                    const SizedBox(width: 14.0),
                    const Text(
                      'Followings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              BlocConsumer<FollowingsBloc, FollowingsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.status == FollowingsStatus.succuss) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                OthersProfileScreen.routeName,
                                arguments: OthersProfileScreenArgs(
                                    othersProfileId: user?.uid)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.name ?? 'N/A',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      Text(
                                        '${user?.username}',
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                  AddToFeedCollectionBtn(
                                    otherUserId: user?.uid,
                                    label: '',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const LoadingIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

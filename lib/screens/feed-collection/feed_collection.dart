import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/constants.dart';
import '/screens/feed-collection/bloc/feed_collection_bloc.dart';
import '/widgets/gradient_circle_button.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/feed/feed_repository.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/loading_indicator.dart';

class FeedCollectionArgs {
  final String? collectionName;

  const FeedCollectionArgs({required this.collectionName});
}

class FeedCollection extends StatelessWidget {
  static const String routeName = '/collectionScreen';

  final String? collectionName;

  const FeedCollection({
    Key? key,
    required this.collectionName,
  }) : super(key: key);

  static Route route({required FeedCollectionArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => FeedCollectionBloc(
          authBloc: context.read<AuthBloc>(),
          feedRepository: context.read<FeedRepository>(),
          collectionName: args.collectionName,
        )..add(LoadStoryCollection()),
        child: FeedCollection(
          collectionName: args.collectionName,
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
        context.read<FeedCollectionBloc>().add(DeleteCollection());
        //context.read<FeedBloc>().add(RefreshFeed());
        Navigator.of(context).pop(true);
        // context.read<FeedBloc>().add(RefreshFeed());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();
    final _canvas = MediaQuery.of(context).size;
    return Container(
      decoration: gradientBackground,
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<FeedCollectionBloc, FeedCollectionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == FeedCollectionStatus.succuss) {
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
                        itemCount: state.users.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 5.0,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if (_authBloc.state.user?.uid ==
                                        user?.uid) {
                                      Navigator.of(context)
                                          .pushNamed(ProfileScreen.routeName);
                                    } else {
                                      Navigator.of(context).pushNamed(
                                        OthersProfileScreen.routeName,
                                        arguments: OthersProfileScreenArgs(
                                            othersProfileId: user?.uid),
                                      );
                                    }
                                  },
                                  child:
                                      AvatarWidget(imageUrl: user?.profilePic)),
                              Text(
                                user?.name ?? 'N/A',
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              )
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
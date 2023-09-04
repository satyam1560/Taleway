import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '/blocs/profile-story/profile_story_cubit.dart';

import '/models/story.dart';
import '/screens/view-story/view_story_screen.dart';
import '/widgets/avatar_widget.dart';

class ProfileStorySection extends StatelessWidget {
  final String? collectionName;

  const ProfileStorySection({Key? key, required this.collectionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileStoryCubit, ProfileStoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == ProfileStoryStatus.succuss) {
            return SizedBox(
              height: 95.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.stories.length,
                itemBuilder: (context, index) {
                  final Story? story = state.stories[index];
                  print('Story url ------- ${story?.storyUrl}');
                  // final name = story?.authorName != null
                  //     ? story!.authorName?.split(' ')[0]
                  //     : 'N/A';
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          ViewStoryScreen.routeName,
                          arguments: ViewStoryScreenArgs(story: story),
                        ),
                        child: AvatarWidget(
                          imageUrl: story?.storyUrl,
                          size: 55.0,
                        ),
                      ),
                      // const Text(
                      //   // name ?? 'N/A',
                      //   'N/A',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w500,
                      //     letterSpacing: 1.0,
                      //   ),
                      // )
                    ],
                  );
                },
              ),
            );
          }
          final int size = state.stories.length;
          return SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFEBEBF4),
              highlightColor: const Color(0xFFF4F4F4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < size; i++)
                    const CircleAvatar(radius: 25.0),
                ],
              ),
            ),
          );
        });

    // FutureBuilder<List<Story?>>(
    //   future: _storyRepo.getStories(
    //       userId: _authBloc.state.user?.uid,
    //       collectionName: collectionName ?? ''),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       final stories = snapshot.data;
    //       return SizedBox(
    //         height: 95.0,
    //         child: ListView.builder(
    //           scrollDirection: Axis.horizontal,
    //           itemCount: stories?.length,
    //           itemBuilder: (context, index) {
    //             final Story? story = stories?[index];
    //             // final name = story?.authorName != null
    //             //     ? story!.authorName?.split(' ')[0]
    //             //     : 'N/A';
    //             return Column(
    //               children: [
    //                 InkWell(
    //                   onTap: () => Navigator.of(context).pushNamed(
    //                     ViewStoryScreen.routeName,
    //                     arguments: ViewStoryScreenArgs(story: story),
    //                   ),
    //                   child: AvatarWidget(
    //                     imageUrl: story?.storyUrl,
    //                     size: 55.0,
    //                   ),
    //                 ),
    //                 // const Text(
    //                 //   // name ?? 'N/A',
    //                 //   'N/A',
    //                 //   style: TextStyle(
    //                 //     color: Colors.white,
    //                 //     fontWeight: FontWeight.w500,
    //                 //     letterSpacing: 1.0,
    //                 //   ),
    //                 // )
    //               ],
    //             );
    //           },
    //         ),
    //       );
    //     }
    //     //return const Center(child: CircularProgressIndicator());

    //     final int size = snapshot.data?.length ?? 0;
    //     return SizedBox(
    //       width: 200.0,
    //       height: 100.0,
    //       child: Shimmer.fromColors(
    //         baseColor: const Color(0xFFEBEBF4),
    //         highlightColor: const Color(0xFFF4F4F4),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             for (int i = 0; i < size; i++) const CircleAvatar(radius: 25.0),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

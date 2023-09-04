import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '/screens/view-story/story_screen.dart';
import '/screens/feed/widgets/cubit/feed_story_cubit.dart';
import '/widgets/avatar_widget.dart';

class FeedStorySection extends StatefulWidget {
  final String? collectionName;

  const FeedStorySection({Key? key, required this.collectionName})
      : super(key: key);

  @override
  State<FeedStorySection> createState() => _FeedStorySectionState();
}

class _FeedStorySectionState extends State<FeedStorySection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        print('Feed scroll controller run ---- ');
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedStoryCubit>().state.status !=
                FeedStoryStatus.paginating) {
          context.read<FeedStoryCubit>().paginatePost();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedStoryCubit, FeedStoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == FeedStoryStatus.succuss) {
          final users = state.users;
          return SizedBox(
            height: 95.0,
            child: ListView.builder(
              ///  controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                final name =
                    user?.name != null ? user?.name!.split(' ')[0] : 'N/A';
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(StoryScreen.routeName,
                            arguments: StoryScreenArgs(authorId: user?.uid));
                      },
                      child: AvatarWidget(
                        imageUrl: user?.profilePic,
                        size: 55.0,
                      ),
                    ),
                    Text(
                      name ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    )
                  ],
                );
              },
            ),
          );
        }
        // return const LoadingIndicator();
        final int size = state.users.length;
        return SizedBox(
          width: double.infinity,
          height: 95.0,
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFEBEBF4),
            highlightColor: const Color(0xFFF4F4F4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < size; i++)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: CircleAvatar(radius: 27.0),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // FutureBuilder<List<Story?>>(
    //   future: _feedRepo.getFeed(
    //     collectionName: collectionName,
    //     userId: _authBloc.state.user?.uid,
    //   ),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       final stories = snapshot.data;

    //       return SizedBox(
    //         height: 95.0,
    //         child: ListView.builder(
    //           scrollDirection: Axis.horizontal,
    //           itemCount: stories?.length,
    //           itemBuilder: (context, index) {
    //             final Story? feedStory = stories?[index];

    //             final name = feedStory?.author?.name != null
    //                 ? feedStory?.author?.name!.split(' ')[0]
    //                 : 'N/A';
    //             return Column(
    //               children: [
    //                 GestureDetector(
    //                   onTap: () {
    //                     Navigator.of(context).pushNamed(
    //                       ViewStoryScreen.routeName,
    //                       arguments: ViewStoryScreenArgs(
    //                         story: stories?[index],
    //                       ),
    //                     );
    //                   },
    //                   child: AvatarWidget(
    //                     // imageUrl: user?.profilePic,
    //                     imageUrl: feedStory?.author?.profilePic,

    //                     size: 55.0,
    //                   ),
    //                 ),
    //                 Text(
    //                   name ?? 'N/A',
    //                   style: const TextStyle(
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.w500,
    //                     letterSpacing: 1.0,
    //                   ),
    //                 )
    //               ],
    //             );
    //           },
    //         ),
    //       );
    //     }
    //     //return const Center(child: CircularProgressIndicator());

    //     final int size = snapshot.data?.length ?? 0;
    //     return SizedBox(
    //       width: double.infinity,
    //       height: 95.0,
    //       child: Shimmer.fromColors(
    //         baseColor: const Color(0xFFEBEBF4),
    //         highlightColor: const Color(0xFFF4F4F4),
    //         child: SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               for (int i = 0; i < size; i++)
    //                 const Padding(
    //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
    //                   child: CircleAvatar(radius: 27.0),
    //                 ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );

    // return SizedBox(
    //     // width: double.infinity,
    //     height: 95.0,
    //     child: ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       itemCount: size,
    //       itemBuilder: (context, index) {
    //         return Shimmer.fromColors(
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                   horizontal: 16.0, vertical: 10.0),
    //               child: Container(
    //                 height: 52.0,
    //                 width: 52.0,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(40.0),
    //                   gradient: const LinearGradient(
    //                     begin: Alignment.topLeft,
    //                     end: Alignment.bottomLeft,
    //                     colors: [
    //                       Colors.pink,
    //                       Colors.purpleAccent,
    //                     ],
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(2.0),
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(60.0),
    //                     child: CircleAvatar(radius: 25.0),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             baseColor: const Color(0xFFEBEBF4),
    //             highlightColor: const Color(0xFFF4F4F4));
    //       },
    //     )

    //     // Shimmer.fromColors(
    //     //   baseColor: const Color(0xFFEBEBF4),
    //     //   highlightColor: const Color(0xFFF4F4F4),
    //     //   child: SingleChildScrollView(
    //     //     scrollDirection: Axis.horizontal,
    //     //     child: Row(
    //     //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     //       children: [
    //     //         for (int i = 0; i < size; i++)
    //     //           const Padding(
    //     //             padding: EdgeInsets.symmetric(
    //     //               horizontal: 16.0,
    //     //               vertical: 10.0,
    //     //             ),
    //     //             child: const CircleAvatar(radius: 27.0),
    //     //           ),
    //     //       ],
    //     //     ),
    //     //   ),
    //     // ),
    //
    //
    //    );
  }
}

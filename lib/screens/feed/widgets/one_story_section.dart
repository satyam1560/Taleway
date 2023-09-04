import 'package:flutter/material.dart';

class OneStorySection extends StatelessWidget {
  final String storyTitle;
  final String storyEmoji;

  const OneStorySection({
    Key? key,
    required this.storyTitle,
    required this.storyEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final _storageRepo = context.read<StoryRepository>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                storyTitle,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                storyEmoji,
                style: const TextStyle(fontSize: 24.0),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          // SizedBox(
          //   height: 95.0,
          //   child: FutureBuilder<List<Story?>>(
          //     future: _storageRepo.getCloseFriendStories(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: snapshot.data?.length,
          //           itemBuilder: (context, index) {
          //             return Shimmer.fromColors(
          //               baseColor: const Color(0xFFEBEBF4),
          //               highlightColor: const Color(0xFFF4F4F4),
          //               child: Column(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.symmetric(
          //                       horizontal: 16.0,
          //                       vertical: 10.0,
          //                     ),
          //                     child: Container(
          //                       height: 55.0,
          //                       width: 55.0,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(40.0),
          //                         gradient: const LinearGradient(
          //                           begin: Alignment.topLeft,
          //                           end: Alignment.bottomLeft,
          //                           colors: [
          //                             Colors.pink,
          //                             Colors.purpleAccent,
          //                           ],
          //                         ),
          //                       ),
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(2.0),
          //                         child: ClipRRect(
          //                           borderRadius: BorderRadius.circular(60.0),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   const Text(
          //                     '',
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontWeight: FontWeight.w500,
          //                       letterSpacing: 1.0,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             );
          //           },
          //         );
          //       }

          //       return ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: snapshot.data?.length,
          //         itemBuilder: (context, index) {
          //           final Story? story = snapshot.data?[index];
          //           final name = story?.taggedUser != null
          //               ? story!.authorId?.split(' ')[0]
          //               : 'N/A';
          //           return Column(
          //             children: [
          //               AvatarWidget(
          //                 imageUrl: story?.storyUrl,
          //                 size: 55.0,
          //               ),
          //               Text(
          //                 name ?? 'N/A',
          //                 style: const TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.w500,
          //                   letterSpacing: 1.0,
          //                 ),
          //               )
          //             ],
          //           );
          //         },
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

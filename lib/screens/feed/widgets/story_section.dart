import 'package:flutter/material.dart';

import '/models/story.dart';
import '/screens/view-story/view_story_screen.dart';
import '/widgets/avatar_widget.dart';

class StorySection extends StatelessWidget {
  final List<Story?> stories;
  final String storyTitle;
  final String storyEmoji;

  const StorySection({
    Key? key,
    required this.stories,
    required this.storyTitle,
    required this.storyEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 95.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final Story? story = stories[index];
                // final name = story?.authorName != null
                //     ? story!.authorName?.split(' ')[0]
                //     : 'N/A';
                return Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ViewStoryScreen(story: story))),
                      child: AvatarWidget(
                        imageUrl: story?.storyUrl,
                        size: 55.0,
                      ),
                    ),
                    //  Text(
                    //    name ?? 'N/A',
                    //  // 'N/A',
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
          )
        ],
      ),
    );
  }
}
